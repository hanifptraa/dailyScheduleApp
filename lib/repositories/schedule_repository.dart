import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/schedule_mode.dart';
import '../models/reminder_models.dart';
import '../models/today_models.dart';
import '../utils/date_utils.dart';
import '../utils/time_utils.dart';

class ScheduleRepository {
  ScheduleRepository(this.db);

  final AppDatabase db;

  Future<void> seedDefaultDataIfNeeded() async {
    final countExp = db.scheduleItems.id.count();
    final count = await (db.selectOnly(db.scheduleItems)
          ..addColumns([countExp]))
        .map((row) => row.read(countExp) ?? 0)
        .getSingle();

    await _seedSettingsIfNeeded();
    if (count > 0) return;

    await db.batch((batch) {
      batch.insertAll(db.scheduleItems, [
        ..._exampleDefaults.map(_toCompanion),
      ]);
    });
  }

  Future<void> _seedSettingsIfNeeded() async {
    final settings = {
      'userName': 'Hanif',
      'themeMode': 'light',
      'targetSleep': '21:00',
      'targetWake': '03:00',
    };

    for (final entry in settings.entries) {
      final existing = await (db.select(db.appSettings)
            ..where((t) => t.key.equals(entry.key)))
          .getSingleOrNull();
      if (existing == null) {
        await db.into(db.appSettings).insert(
              AppSettingsCompanion.insert(
                key: entry.key,
                value: entry.value,
              ),
            );
      }
    }
  }

  Future<String> getSetting(String key, String fallback) async {
    final row = await (db.select(db.appSettings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value ?? fallback;
  }

  Future<Map<String, String>> getSettings() async {
    final rows = await db.select(db.appSettings).get();
    return {for (final row in rows) row.key: row.value};
  }

  Future<bool> isGuidedTutorialCompleted() async {
    return await getSetting('guidedTutorialCompleted', 'false') == 'true';
  }

  Future<void> completeGuidedTutorial() async {
    await setSetting('guidedTutorialCompleted', 'true');
  }

  Future<void> resetGuidedTutorial() async {
    await setSetting('guidedTutorialCompleted', 'false');
  }

  Future<void> setSetting(String key, String value) async {
    final now = DateTime.now();
    final existing = await (db.select(db.appSettings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    if (existing == null) {
      await db.into(db.appSettings).insert(
            AppSettingsCompanion.insert(
              key: key,
              value: value,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    } else {
      await (db.update(db.appSettings)..where((t) => t.key.equals(key))).write(
        AppSettingsCompanion(value: Value(value), updatedAt: Value(now)),
      );
    }
  }

  Future<List<ScheduleModeOption>> getScheduleModes() async {
    final rows = await (db.select(db.scheduleItems)
          ..where((t) => t.isActive.equals(true)))
        .get();
    final byCode = <String, ScheduleModeOption>{};

    for (final row in rows) {
      final mode = ScheduleModeOption.fromCode(row.scheduleMode);
      if (mode.code.isNotEmpty) byCode[mode.code] = mode;
    }

    for (final code
        in _decodeCustomModes(await getSetting('customModes', ''))) {
      final mode = ScheduleModeOption.fromCode(code);
      if (mode.code.isNotEmpty) byCode[mode.code] = mode;
    }

    final modes = byCode.values.toList()
      ..sort((a, b) {
        final aDefault = ScheduleModeOption.defaults.contains(a);
        final bDefault = ScheduleModeOption.defaults.contains(b);
        if (aDefault != bDefault) return aDefault ? -1 : 1;
        return a.label.toLowerCase().compareTo(b.label.toLowerCase());
      });
    return modes.isEmpty ? [ScheduleModeOption.regular] : modes;
  }

  Future<List<String>> getCategories() async {
    final rows = await db.select(db.scheduleItems).get();
    final values = <String>{...defaultCategories};
    for (final row in rows) {
      for (final category in parseCategories(row.category)) {
        values.add(category);
      }
    }
    final list = values.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  List<String> _decodeCustomModes(String value) {
    return value
        .split('|')
        .map(ScheduleModeOption.normalizeCustomCode)
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList();
  }

  Future<void> _setCustomModes(List<String> modes) async {
    final normalized = modes
        .map(ScheduleModeOption.normalizeCustomCode)
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    await setSetting('customModes', normalized.join('|'));
  }

  Future<void> createScheduleMode(ScheduleModeOption mode) async {
    final normalized = ScheduleModeOption.normalizeCustomCode(mode.label);
    if (normalized.isEmpty) return;
    final modes = _decodeCustomModes(await getSetting('customModes', ''));
    if (!modes.any((item) => item.toLowerCase() == normalized.toLowerCase())) {
      modes.add(normalized);
      await _setCustomModes(modes);
    }
  }

  Future<void> renameScheduleMode({
    required ScheduleModeOption oldMode,
    required ScheduleModeOption newMode,
  }) async {
    final normalized = ScheduleModeOption.normalizeCustomCode(newMode.label);
    if (normalized.isEmpty || normalized == oldMode.code) return;
    final target = ScheduleModeOption(code: normalized, label: normalized);
    final now = DateTime.now();

    final customModes = _decodeCustomModes(await getSetting('customModes', ''));
    final renamedModes = customModes
        .map((item) => item == oldMode.code ? target.code : item)
        .toList();
    await _setCustomModes(renamedModes);

    await db.transaction(() async {
      await (db.update(db.scheduleItems)
            ..where((t) => t.scheduleMode.equals(oldMode.code)))
          .write(ScheduleItemsCompanion(
        scheduleMode: Value(target.code),
        updatedAt: Value(now),
      ));
      await (db.update(db.dailyModes)
            ..where((t) => t.scheduleMode.equals(oldMode.code)))
          .write(DailyModesCompanion(
        scheduleMode: Value(target.code),
        updatedAt: Value(now),
      ));
      await (db.update(db.dailyChecklists)
            ..where((t) => t.scheduleMode.equals(oldMode.code)))
          .write(DailyChecklistsCompanion(
        scheduleMode: Value(target.code),
        updatedAt: Value(now),
      ));
    });
  }

  Future<void> deleteScheduleMode(ScheduleModeOption mode) async {
    final customModes = _decodeCustomModes(await getSetting('customModes', ''))
      ..removeWhere((item) => item == mode.code);
    await _setCustomModes(customModes);
    final now = DateTime.now();
    await (db.update(db.scheduleItems)
          ..where((t) => t.scheduleMode.equals(mode.code)))
        .write(ScheduleItemsCompanion(
      isActive: const Value(false),
      updatedAt: Value(now),
    ));
  }

  Future<void> deleteCategory(String category) async {
    final target = normalizeCategoryName(category);
    if (target.isEmpty) return;
    final rows = await db.select(db.scheduleItems).get();
    final now = DateTime.now();
    for (final row in rows) {
      final categories = parseCategories(row.category);
      if (!categories.contains(target)) continue;
      final remaining = categories.where((item) => item != target).toList();
      final nextValue = remaining.isEmpty
          ? defaultCategories.first
          : encodeCategories(remaining);
      await (db.update(db.scheduleItems)..where((t) => t.id.equals(row.id)))
          .write(
        ScheduleItemsCompanion(
          category: Value(nextValue),
          updatedAt: Value(now),
        ),
      );
    }
  }

  Future<ScheduleModeOption> getDailyMode(String dateKey) async {
    final row = await (db.select(db.dailyModes)
          ..where((t) => t.date.equals(dateKey)))
        .getSingleOrNull();
    if (row != null) return ScheduleModeOption.fromCode(row.scheduleMode);

    await setDailyMode(dateKey, ScheduleModeOption.regular);
    return ScheduleModeOption.regular;
  }

  Future<void> setDailyMode(String dateKey, ScheduleModeOption mode) async {
    final now = DateTime.now();
    final existing = await (db.select(db.dailyModes)
          ..where((t) => t.date.equals(dateKey)))
        .getSingleOrNull();
    if (existing == null) {
      await db.into(db.dailyModes).insert(
            DailyModesCompanion.insert(
              date: dateKey,
              scheduleMode: mode.code,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    } else {
      await (db.update(db.dailyModes)..where((t) => t.date.equals(dateKey)))
          .write(
        DailyModesCompanion(
            scheduleMode: Value(mode.code), updatedAt: Value(now)),
      );
    }

    await ensureChecklistRowsForDate(dateKey, mode);
  }

  Future<List<ScheduleItem>> getActiveScheduleItems(
      ScheduleModeOption mode) async {
    final rows = await (db.select(db.scheduleItems)
          ..where((t) =>
              t.isActive.equals(true) & t.scheduleMode.equals(mode.code)))
        .get();
    rows.sort((a, b) => AppTimeUtils.toMinutes(a.startTime)
        .compareTo(AppTimeUtils.toMinutes(b.startTime)));
    return rows;
  }

  Future<void> ensureChecklistRowsForDate(
      String dateKey, ScheduleModeOption mode) async {
    final items = await getActiveScheduleItems(mode);
    final existing = await (db.select(db.dailyChecklists)
          ..where(
              (t) => t.date.equals(dateKey) & t.scheduleMode.equals(mode.code)))
        .get();
    final existingIds = existing.map((row) => row.scheduleItemId).toSet();
    final now = DateTime.now();

    for (final item in items) {
      if (existingIds.contains(item.id)) continue;
      await db.into(db.dailyChecklists).insert(
            DailyChecklistsCompanion.insert(
              scheduleItemId: item.id,
              date: dateKey,
              scheduleMode: item.scheduleMode,
              isDone: const Value(false),
              completedAt: const Value<DateTime?>(null),
              snapshotTitle: item.title,
              snapshotDescription: Value<String?>(item.description),
              snapshotStartTime: item.startTime,
              snapshotEndTime: item.endTime,
              snapshotCategory: item.category,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    }
  }

  Future<TodayData> getTodayData(DateTime date) async {
    final key = AppDateUtils.dateKey(date);
    final mode = await getDailyMode(key);
    await ensureChecklistRowsForDate(key, mode);

    final items = await getActiveScheduleItems(mode);
    final checks = await (db.select(db.dailyChecklists)
          ..where((t) => t.date.equals(key) & t.scheduleMode.equals(mode.code)))
        .get();
    final checkMap = {for (final check in checks) check.scheduleItemId: check};

    return TodayData(
      dateKey: key,
      mode: mode,
      entries: [
        for (final item in items)
          TodayScheduleEntry(
            item: item,
            checklist: checkMap[item.id],
          ),
      ],
    );
  }

  Future<void> setChecklistDone({
    required String dateKey,
    required ScheduleModeOption mode,
    required ScheduleItem item,
    required bool isDone,
  }) async {
    final now = DateTime.now();
    final updated = await (db.update(db.dailyChecklists)
          ..where((t) =>
              t.date.equals(dateKey) &
              t.scheduleMode.equals(mode.code) &
              t.scheduleItemId.equals(item.id)))
        .write(
      DailyChecklistsCompanion(
        isDone: Value(isDone),
        completedAt: Value(isDone ? now : null),
        updatedAt: Value(now),
      ),
    );

    if (updated > 0) return;

    await ensureChecklistRowsForDate(dateKey, mode);
    await (db.update(db.dailyChecklists)
          ..where((t) =>
              t.date.equals(dateKey) &
              t.scheduleMode.equals(mode.code) &
              t.scheduleItemId.equals(item.id)))
        .write(
      DailyChecklistsCompanion(
        isDone: Value(isDone),
        completedAt: Value(isDone ? now : null),
        updatedAt: Value(now),
      ),
    );
  }

  Future<ScheduleItem?> getScheduleItemById(int id) async {
    return (db.select(db.scheduleItems)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> createScheduleItem({
    required String title,
    String? description,
    required String startTime,
    required String endTime,
    required String category,
    required ScheduleModeOption mode,
    required bool enableNotification,
    required int notifyBeforeMinutes,
    String reminderType = 'notification',
    int reminderOffsetMinutes = 0,
    String alarmSound = 'default',
    bool vibrate = true,
    bool enableAlarm = false,
  }) async {
    final now = DateTime.now();
    return db.into(db.scheduleItems).insert(
          ScheduleItemsCompanion.insert(
            title: title,
            description: Value(description == null || description.trim().isEmpty
                ? null
                : description.trim()),
            startTime: startTime,
            endTime: endTime,
            category: normalizeCategoryValue(category),
            scheduleMode: mode.code,
            isActive: const Value(true),
            enableNotification: Value(enableNotification),
            notifyBeforeMinutes: Value(notifyBeforeMinutes),
            reminderType: Value(ReminderType.fromValue(reminderType).value),
            reminderOffsetMinutes: Value(reminderOffsetMinutes),
            alarmSound: Value(AlarmSoundOption.fromValue(alarmSound).value),
            vibrate: Value(vibrate),
            enableAlarm: Value(enableAlarm),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> updateScheduleItem({
    required int id,
    required String title,
    String? description,
    required String startTime,
    required String endTime,
    required String category,
    required ScheduleModeOption mode,
    required bool isActive,
    required bool enableNotification,
    required int notifyBeforeMinutes,
    String reminderType = 'notification',
    int reminderOffsetMinutes = 0,
    String alarmSound = 'default',
    bool vibrate = true,
    bool enableAlarm = false,
  }) async {
    await (db.update(db.scheduleItems)..where((t) => t.id.equals(id))).write(
      ScheduleItemsCompanion(
        title: Value(title),
        description: Value(description == null || description.trim().isEmpty
            ? null
            : description.trim()),
        startTime: Value(startTime),
        endTime: Value(endTime),
        category: Value(normalizeCategoryValue(category)),
        scheduleMode: Value(mode.code),
        isActive: Value(isActive),
        enableNotification: Value(enableNotification),
        notifyBeforeMinutes: Value(notifyBeforeMinutes),
        reminderType: Value(ReminderType.fromValue(reminderType).value),
        reminderOffsetMinutes: Value(reminderOffsetMinutes),
        alarmSound: Value(AlarmSoundOption.fromValue(alarmSound).value),
        vibrate: Value(vibrate),
        enableAlarm: Value(enableAlarm),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> softDeleteScheduleItem(int id) async {
    await (db.update(db.scheduleItems)..where((t) => t.id.equals(id))).write(
      ScheduleItemsCompanion(
          isActive: const Value(false), updatedAt: Value(DateTime.now())),
    );
  }

  Future<List<HistoryDayData>> getHistory() async {
    final checks = await (db.select(db.dailyChecklists)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
    final modes = await db.select(db.dailyModes).get();
    final modeMap = {
      for (final m in modes) m.date: ScheduleModeOption.fromCode(m.scheduleMode)
    };

    final grouped = <String, List<DailyChecklist>>{};
    for (final check in checks) {
      grouped.putIfAbsent(check.date, () => []).add(check);
    }

    final days = grouped.entries.map((entry) {
      final mode = modeMap[entry.key] ?? ScheduleModeOption.regular;
      final modeItems =
          entry.value.where((item) => item.scheduleMode == mode.code).toList();
      return HistoryDayData(
        dateKey: entry.key,
        mode: mode,
        total: modeItems.length,
        done: modeItems.where((item) => item.isDone).length,
        items: modeItems,
      );
    }).toList();

    days.sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return days;
  }

  Future<StatisticsData> getStatistics() async {
    final today = await getTodayData(DateTime.now());
    final history = await getHistory();
    final last7 = history.take(7).toList();
    final avg = last7.isEmpty
        ? today.percent
        : (last7.map((e) => e.percent).reduce((a, b) => a + b) / last7.length)
            .round();
    final productiveDays = history.where((d) => d.percent >= 70).length;

    int streak = 0;
    final todayDate = DateTime.now();
    for (var i = 0; i < 365; i++) {
      final key = AppDateUtils.dateKey(todayDate.subtract(Duration(days: i)));
      HistoryDayData? day;
      for (final candidate in history) {
        if (candidate.dateKey == key) {
          day = candidate;
          break;
        }
      }
      if (day == null || day.percent < 70) break;
      streak++;
    }

    final doneCategoryCount = <String, int>{};
    final totalCategoryCount = <String, int>{};
    var totalTasks = 0;
    var completedTasks = 0;

    for (final day in history) {
      for (final item in day.items) {
        totalTasks++;
        final itemCategories = parseCategories(item.snapshotCategory);
        final categories = itemCategories.isEmpty ? ['-'] : itemCategories;
        for (final category in categories) {
          totalCategoryCount[category] =
              (totalCategoryCount[category] ?? 0) + 1;
          if (item.isDone) {
            doneCategoryCount[category] =
                (doneCategoryCount[category] ?? 0) + 1;
          }
        }
        if (item.isDone) completedTasks++;
      }
    }

    final categories = totalCategoryCount.entries.map((entry) {
      return CategoryPerformance(
        category: entry.key,
        done: doneCategoryCount[entry.key] ?? 0,
        total: entry.value,
      );
    }).toList()
      ..sort((a, b) {
        final byTotal = b.total.compareTo(a.total);
        if (byTotal != 0) return byTotal;
        return b.percent.compareTo(a.percent);
      });

    final trend = last7.reversed.map((day) {
      return TrendPoint(
        dateKey: day.dateKey,
        percent: day.percent,
        done: day.done,
        total: day.total,
      );
    }).toList();

    HistoryDayData? bestDay;
    for (final day in history) {
      if (bestDay == null || day.percent > bestDay.percent) bestDay = day;
    }

    final completionRate = totalTasks == 0
        ? today.percent
        : ((completedTasks / totalTasks) * 100).round();
    final strongestCategory =
        completedTasks == 0 ? '-' : _topCategory(doneCategoryCount);
    final attentionCategory = _attentionCategory(
      categories: categories,
      strongestCategory: strongestCategory,
      completionRate: completionRate,
    );

    return StatisticsData(
      todayPercent: today.percent,
      last7Average: avg,
      productiveDays: productiveDays,
      streak: streak,
      mostDoneCategory: strongestCategory,
      mostMissedCategory: completedTasks == 0 ? '-' : attentionCategory,
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      completionRate: completionRate,
      consistencyScore: avg,
      bestDayLabel: completedTasks == 0 || bestDay == null
          ? '-'
          : AppDateUtils.formatDateKey(bestDay.dateKey),
      bestDayPercent: completedTasks == 0 ? 0 : bestDay?.percent ?? 0,
      trend: trend,
      categories: categories.take(6).toList(),
    );
  }

  String _attentionCategory({
    required List<CategoryPerformance> categories,
    required String strongestCategory,
    required int completionRate,
  }) {
    if (categories.isEmpty) return '-';
    if (completionRate >= 90 &&
        categories.every((item) => item.total > 0 && item.percent >= 90)) {
      return 'Tidak ada, pertahankan';
    }

    final candidates = categories
        .where((item) =>
            item.category != strongestCategory &&
            item.total > 0 &&
            item.percent < 70)
        .toList();

    final fallbackCandidates = candidates.isEmpty
        ? categories.where((item) => item.total > 0).toList()
        : candidates;

    fallbackCandidates.sort((a, b) {
      final byPercent = a.percent.compareTo(b.percent);
      if (byPercent != 0) return byPercent;
      return b.total.compareTo(a.total);
    });

    if (fallbackCandidates.isEmpty) return '-';
    return fallbackCandidates.first.category;
  }

  String _topCategory(Map<String, int> data) {
    if (data.isEmpty) return '-';
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.first.key;
  }

  Future<void> resetSchedulesToDefault() async {
    final now = DateTime.now();
    await (db.update(db.scheduleItems)).write(
      ScheduleItemsCompanion(
          isActive: const Value(false), updatedAt: Value(now)),
    );
    await db.batch((batch) {
      batch.insertAll(db.scheduleItems, [
        ..._exampleDefaults.map(_toCompanion),
      ]);
    });
  }

  Future<void> deleteHistoryDay(String dateKey) async {
    await db.transaction(() async {
      await (db.delete(db.dailyChecklists)
            ..where((t) => t.date.equals(dateKey)))
          .go();
      await (db.delete(db.dailyModes)..where((t) => t.date.equals(dateKey)))
          .go();
    });
  }

  Future<void> clearChecklistData() async {
    await db.delete(db.dailyChecklists).go();
    await db.delete(db.dailyModes).go();
  }

  ScheduleItemsCompanion _toCompanion(_SeedSchedule item) {
    final now = DateTime.now();
    return ScheduleItemsCompanion.insert(
      title: item.title,
      startTime: item.start,
      endTime: item.end,
      category: item.category,
      scheduleMode: item.mode.code,
      description: const Value(null),
      isActive: const Value(true),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }
}

class _SeedSchedule {
  const _SeedSchedule(
      this.start, this.end, this.title, this.category, this.mode);
  final String start;
  final String end;
  final String title;
  final String category;
  final ScheduleModeOption mode;
}

const _exampleDefaults = [
  _SeedSchedule(
      '03:00',
      '03:15',
      'Bangun pagi, rapikan tempat tidur, minum air',
      'Persiapan',
      ScheduleModeOption.regular),
  _SeedSchedule('03:15', '03:30', 'Wudhu dan persiapan tahajjud', 'Persiapan',
      ScheduleModeOption.regular),
  _SeedSchedule('03:30', '04:05', 'Sholat tahajjud dan doa pribadi', 'Ibadah',
      ScheduleModeOption.regular),
  _SeedSchedule('04:05', '04:35', 'Baca Qur\'an, hafalan pendek, dan dzikir',
      'Ibadah', ScheduleModeOption.regular),
  _SeedSchedule('04:35', '05:10', 'Sholat Subuh berjamaah / tepat waktu',
      'Ibadah', ScheduleModeOption.regular),
  _SeedSchedule(
      '05:10',
      '06:15',
      'Olahraga pagi: jalan, jogging, atau stretching',
      'Olahraga',
      ScheduleModeOption.regular),
  _SeedSchedule('06:15', '06:45', 'Pulang, pendinginan, dan istirahat ringan',
      'Istirahat, Rutinitas', ScheduleModeOption.regular),
  _SeedSchedule('06:45', '07:30', 'Mandi, sarapan, dan persiapan belajar',
      'Rutinitas', ScheduleModeOption.regular),
  _SeedSchedule(
      '07:30',
      '09:30',
      'Belajar fokus: pelajaran utama / tugas sekolah',
      'Kerja / Belajar',
      ScheduleModeOption.regular),
  _SeedSchedule('09:30', '10:00', 'Istirahat singkat dan sholat Dhuha',
      'Ibadah', ScheduleModeOption.regular),
  _SeedSchedule(
      '10:00',
      '11:45',
      'Lanjut belajar: latihan soal dan catatan ringkas',
      'Kerja / Belajar',
      ScheduleModeOption.regular),
  _SeedSchedule('11:45', '12:30', 'Sholat Dzuhur dan makan siang', 'Ibadah',
      ScheduleModeOption.regular),
  _SeedSchedule('12:30', '13:15', 'Tidur siang / istirahat agar tetap segar',
      'Istirahat', ScheduleModeOption.regular),
  _SeedSchedule(
      '13:15',
      '15:00',
      'Review materi, mengerjakan PR, atau project kecil',
      'Kerja / Belajar, Project',
      ScheduleModeOption.regular),
  _SeedSchedule('15:00', '15:35', 'Sholat Ashar dan dzikir sore', 'Ibadah',
      ScheduleModeOption.regular),
  _SeedSchedule(
      '15:35',
      '17:00',
      'Bantu orang tua, beres kamar, atau aktivitas rumah',
      'Rutinitas',
      ScheduleModeOption.regular),
  _SeedSchedule('17:00', '17:45', 'Murajaah hafalan / baca buku ringan',
      'Ibadah, Kerja / Belajar', ScheduleModeOption.regular),
  _SeedSchedule(
      '18:00',
      '19:00',
      'Sholat Maghrib, tilawah ringan, dan makan malam',
      'Ibadah',
      ScheduleModeOption.regular),
  _SeedSchedule(
      '19:00', '19:30', 'Sholat Isya', 'Ibadah', ScheduleModeOption.regular),
  _SeedSchedule(
      '19:30',
      '20:30',
      'Review pelajaran hari ini dan siapkan agenda besok',
      'Review, Planning',
      ScheduleModeOption.regular),
  _SeedSchedule(
      '20:30',
      '21:00',
      'Persiapan tidur, evaluasi diri, dan doa malam',
      'Istirahat, Review',
      ScheduleModeOption.regular),
];
