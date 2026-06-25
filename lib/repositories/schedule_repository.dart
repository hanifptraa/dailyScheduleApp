import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/schedule_mode.dart';
import '../models/today_models.dart';
import '../utils/date_utils.dart';
import '../utils/time_utils.dart';

class ScheduleRepository {
  ScheduleRepository(this.db);

  final AppDatabase db;

  Future<void> seedDefaultDataIfNeeded() async {
    final countExp = db.scheduleItems.id.count();
    final count = await (db.selectOnly(db.scheduleItems)..addColumns([countExp]))
        .map((row) => row.read(countExp) ?? 0)
        .getSingle();

    await _seedSettingsIfNeeded();
    if (count > 0) return;

    await db.batch((batch) {
      batch.insertAll(db.scheduleItems, [
        ..._regularDefaults.map(_toCompanion),
        ..._basketDefaults.map(_toCompanion),
      ]);
    });
  }

  Future<void> _seedSettingsIfNeeded() async {
    final settings = {
      'userName': 'Hanif',
      'themeMode': 'system',
      'targetSleep': '21:00',
      'targetWake': '03:00',
    };

    for (final entry in settings.entries) {
      final existing = await (db.select(db.appSettings)..where((t) => t.key.equals(entry.key))).getSingleOrNull();
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
    final row = await (db.select(db.appSettings)..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value ?? fallback;
  }

  Future<Map<String, String>> getSettings() async {
    final rows = await db.select(db.appSettings).get();
    return {for (final row in rows) row.key: row.value};
  }

  Future<void> setSetting(String key, String value) async {
    final now = DateTime.now();
    final existing = await (db.select(db.appSettings)..where((t) => t.key.equals(key))).getSingleOrNull();
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

  Future<ScheduleModeType> getDailyMode(String dateKey) async {
    final row = await (db.select(db.dailyModes)..where((t) => t.date.equals(dateKey))).getSingleOrNull();
    if (row != null) return ScheduleModeType.fromCode(row.scheduleMode);

    await setDailyMode(dateKey, ScheduleModeType.regular);
    return ScheduleModeType.regular;
  }

  Future<void> setDailyMode(String dateKey, ScheduleModeType mode) async {
    final now = DateTime.now();
    final existing = await (db.select(db.dailyModes)..where((t) => t.date.equals(dateKey))).getSingleOrNull();
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
      await (db.update(db.dailyModes)..where((t) => t.date.equals(dateKey))).write(
        DailyModesCompanion(scheduleMode: Value(mode.code), updatedAt: Value(now)),
      );
    }

    await ensureChecklistRowsForDate(dateKey, mode);
  }

  Future<List<ScheduleItem>> getActiveScheduleItems(ScheduleModeType mode) async {
    final rows = await (db.select(db.scheduleItems)
          ..where((t) => t.isActive.equals(true) & t.scheduleMode.equals(mode.code)))
        .get();
    rows.sort((a, b) => AppTimeUtils.toMinutes(a.startTime).compareTo(AppTimeUtils.toMinutes(b.startTime)));
    return rows;
  }

  Future<void> ensureChecklistRowsForDate(String dateKey, ScheduleModeType mode) async {
    final items = await getActiveScheduleItems(mode);
    final existing = await (db.select(db.dailyChecklists)
          ..where((t) => t.date.equals(dateKey) & t.scheduleMode.equals(mode.code)))
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
    required ScheduleModeType mode,
    required ScheduleItem item,
    required bool isDone,
  }) async {
    await ensureChecklistRowsForDate(dateKey, mode);
    final now = DateTime.now();
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

  Future<int> createScheduleItem({
    required String title,
    String? description,
    required String startTime,
    required String endTime,
    required String category,
    required ScheduleModeType mode,
  }) async {
    final now = DateTime.now();
    return db.into(db.scheduleItems).insert(
          ScheduleItemsCompanion.insert(
            title: title,
            description: Value(description?.trim().isEmpty == true ? null : description),
            startTime: startTime,
            endTime: endTime,
            category: category,
            scheduleMode: mode.code,
            isActive: const Value(true),
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
    required ScheduleModeType mode,
    required bool isActive,
  }) async {
    await (db.update(db.scheduleItems)..where((t) => t.id.equals(id))).write(
      ScheduleItemsCompanion(
        title: Value(title),
        description: Value(description?.trim().isEmpty == true ? null : description),
        startTime: Value(startTime),
        endTime: Value(endTime),
        category: Value(category),
        scheduleMode: Value(mode.code),
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> softDeleteScheduleItem(int id) async {
    await (db.update(db.scheduleItems)..where((t) => t.id.equals(id))).write(
      ScheduleItemsCompanion(isActive: const Value(false), updatedAt: Value(DateTime.now())),
    );
  }

  Future<List<HistoryDayData>> getHistory() async {
    final checks = await (db.select(db.dailyChecklists)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
    final modes = await db.select(db.dailyModes).get();
    final modeMap = {for (final m in modes) m.date: ScheduleModeType.fromCode(m.scheduleMode)};

    final grouped = <String, List<DailyChecklist>>{};
    for (final check in checks) {
      grouped.putIfAbsent(check.date, () => []).add(check);
    }

    final days = grouped.entries.map((entry) {
      final mode = modeMap[entry.key] ?? ScheduleModeType.regular;
      final modeItems = entry.value.where((item) => item.scheduleMode == mode.code).toList();
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
    final avg = last7.isEmpty ? today.percent : (last7.map((e) => e.percent).reduce((a, b) => a + b) / last7.length).round();
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
    final missedCategoryCount = <String, int>{};
    for (final day in history) {
      for (final item in day.items) {
        final target = item.isDone ? doneCategoryCount : missedCategoryCount;
        target[item.snapshotCategory] = (target[item.snapshotCategory] ?? 0) + 1;
      }
    }

    return StatisticsData(
      todayPercent: today.percent,
      last7Average: avg,
      productiveDays: productiveDays,
      streak: streak,
      mostDoneCategory: _topCategory(doneCategoryCount),
      mostMissedCategory: _topCategory(missedCategoryCount),
    );
  }

  String _topCategory(Map<String, int> data) {
    if (data.isEmpty) return '-';
    final entries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return entries.first.key;
  }

  Future<void> resetSchedulesToDefault() async {
    final now = DateTime.now();
    await (db.update(db.scheduleItems)).write(
      ScheduleItemsCompanion(isActive: const Value(false), updatedAt: Value(now)),
    );
    await db.batch((batch) {
      batch.insertAll(db.scheduleItems, [
        ..._regularDefaults.map(_toCompanion),
        ..._basketDefaults.map(_toCompanion),
      ]);
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
  const _SeedSchedule(this.start, this.end, this.title, this.category, this.mode);
  final String start;
  final String end;
  final String title;
  final String category;
  final ScheduleModeType mode;
}

const _regularDefaults = [
  _SeedSchedule('03:00', '03:15', 'Bangun, wudhu, minum air', 'Persiapan', ScheduleModeType.regular),
  _SeedSchedule('03:15', '04:15', 'Sholat Tahajud + Dzikir', 'Ibadah', ScheduleModeType.regular),
  _SeedSchedule('04:15', '05:00', 'Baca Qur’an sampai Subuh', 'Ibadah', ScheduleModeType.regular),
  _SeedSchedule('05:00', '07:00', 'Belajar Basic PHP/Laravel', 'Coding', ScheduleModeType.regular),
  _SeedSchedule('07:00', '07:30', 'Sholat Dhuha', 'Ibadah', ScheduleModeType.regular),
  _SeedSchedule('07:30', '08:00', 'Sarapan, mandi, beres kamar', 'Rutinitas', ScheduleModeType.regular),
  _SeedSchedule('08:00', '10:00', 'Project / Roblox Studio', 'Project', ScheduleModeType.regular),
  _SeedSchedule('10:00', '10:45', 'Workout tipis / Ball Handling Basket', 'Olahraga', ScheduleModeType.regular),
  _SeedSchedule('10:45', '11:15', 'Pendinginan, mandi, siap Dzuhur', 'Rutinitas', ScheduleModeType.regular),
  _SeedSchedule('12:00', '12:30', 'Sholat Dzuhur + Sunnah Qobliyah/Ba’diyah', 'Ibadah', ScheduleModeType.regular),
  _SeedSchedule('12:30', '13:00', 'Makan siang', 'Rutinitas', ScheduleModeType.regular),
  _SeedSchedule('13:00', '14:15', 'Tidur siang', 'Istirahat', ScheduleModeType.regular),
  _SeedSchedule('14:15', '15:15', 'Konten / Digital Skill', 'Digital Skill', ScheduleModeType.regular),
  _SeedSchedule('15:30', '16:00', 'Sholat Ashar + dzikir pendek', 'Ibadah', ScheduleModeType.regular),
  _SeedSchedule('16:00', '17:15', 'Review project / aktivitas ringan', 'Review', ScheduleModeType.regular),
  _SeedSchedule('18:00', '19:00', 'Maghrib, Qur’an ringan, makan malam', 'Ibadah', ScheduleModeType.regular),
  _SeedSchedule('19:00', '19:30', 'Sholat Isya', 'Ibadah', ScheduleModeType.regular),
  _SeedSchedule('19:30', '20:30', 'Review hari ini + planning besok', 'Planning', ScheduleModeType.regular),
  _SeedSchedule('20:30', '21:00', 'Persiapan tidur', 'Istirahat', ScheduleModeType.regular),
];

const _basketDefaults = [
  _SeedSchedule('03:00', '03:15', 'Bangun, wudhu, minum air', 'Persiapan', ScheduleModeType.basket),
  _SeedSchedule('03:15', '04:15', 'Sholat Tahajud + Dzikir', 'Ibadah', ScheduleModeType.basket),
  _SeedSchedule('04:15', '05:00', 'Baca Qur’an sampai Subuh', 'Ibadah', ScheduleModeType.basket),
  _SeedSchedule('05:00', '05:40', 'Review Laravel ringan', 'Coding', ScheduleModeType.basket),
  _SeedSchedule('05:40', '06:00', 'Persiapan basket', 'Olahraga', ScheduleModeType.basket),
  _SeedSchedule('06:00', '08:30', 'Basket', 'Olahraga', ScheduleModeType.basket),
  _SeedSchedule('08:30', '09:30', 'Pulang, mandi, sarapan', 'Rutinitas', ScheduleModeType.basket),
  _SeedSchedule('09:30', '11:00', 'Project ringan', 'Project', ScheduleModeType.basket),
  _SeedSchedule('12:00', '12:30', 'Sholat Dzuhur + Sunnah Qobliyah/Ba’diyah', 'Ibadah', ScheduleModeType.basket),
  _SeedSchedule('12:30', '13:00', 'Makan siang', 'Rutinitas', ScheduleModeType.basket),
  _SeedSchedule('13:00', '14:30', 'Tidur siang', 'Istirahat', ScheduleModeType.basket),
  _SeedSchedule('14:30', '15:30', 'Konten / edit video / digital skill', 'Digital Skill', ScheduleModeType.basket),
  _SeedSchedule('15:30', '16:00', 'Sholat Ashar', 'Ibadah', ScheduleModeType.basket),
  _SeedSchedule('16:00', '17:00', 'Aktivitas ringan / recovery', 'Istirahat', ScheduleModeType.basket),
  _SeedSchedule('18:00', '19:00', 'Maghrib, Qur’an ringan, makan malam', 'Ibadah', ScheduleModeType.basket),
  _SeedSchedule('19:00', '19:30', 'Sholat Isya', 'Ibadah', ScheduleModeType.basket),
  _SeedSchedule('19:30', '20:30', 'Review hari ini + planning besok', 'Planning', ScheduleModeType.basket),
  _SeedSchedule('20:30', '21:00', 'Persiapan tidur', 'Istirahat', ScheduleModeType.basket),
];
