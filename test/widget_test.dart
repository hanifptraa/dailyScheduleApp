import 'package:daily_schedule/app.dart';
import 'package:daily_schedule/database/app_database.dart';
import 'package:daily_schedule/providers/app_providers.dart';
import 'package:daily_schedule/repositories/schedule_repository.dart';
import 'package:daily_schedule/models/schedule_mode.dart';
import 'package:daily_schedule/utils/time_utils.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppTimeUtils converts and validates HH:mm values', () {
    expect(AppTimeUtils.toMinutes('08:30'), 510);
    expect(AppTimeUtils.fromTimeOfDay(const TimeOfDay(hour: 9, minute: 5)),
        '09:05');
    expect(AppTimeUtils.isValidRange('08:00', '09:00'), isTrue);
    expect(AppTimeUtils.isValidRange('10:00', '09:00'), isTrue);
    expect(AppTimeUtils.isValidRange('21:00', '03:00'), isTrue);
    expect(AppTimeUtils.isValidRange('10:00', '10:00'), isFalse);
  });

  test('Statistics insight is positive when all agenda is completed', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ScheduleRepository(database);
    await repository.seedDefaultDataIfNeeded();

    final today = await repository.getTodayData(DateTime.now());
    for (final entry in today.entries) {
      await repository.setChecklistDone(
        dateKey: today.dateKey,
        mode: ScheduleModeOption.regular,
        item: entry.item,
        isDone: true,
      );
    }

    final stats = await repository.getStatistics();
    expect(stats.completionRate, 100);
    expect(stats.mostMissedCategory, 'Tidak ada, pertahankan');
  });

  testWidgets('Animated intro appears before main app', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ScheduleRepository(database);
    await repository.seedDefaultDataIfNeeded();
    await repository.completeGuidedTutorial();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const DailyScheduleApp(),
      ),
    );

    expect(find.text('Daily Schedule'), findsOneWidget);
    expect(find.text('Atur hari. Jaga disiplin.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 6200));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Hari Ini'), findsWidgets);
    expect(find.text('Atur hari. Jaga disiplin.'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Guided tutorial prompt can start, advance, and skip safely',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ScheduleRepository(database);
    await repository.seedDefaultDataIfNeeded();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const DailyScheduleApp(),
      ),
    );

    await _pumpUntilFound(tester, find.text('Mau lihat tutorial singkat?'));
    await tester.tap(find.text('Mulai Tutorial'));
    await _pumpUntilFound(tester, find.textContaining('Ini halaman utama'));

    await tester.tap(find.text('Lanjut'));
    await _pumpUntilFound(tester, find.text('Progress Harian'));
    await tester.tap(find.text('Lanjut'));
    await _pumpUntilFound(tester, find.text('Mode Hari'));
    await tester.tap(find.text('Lanjut'));
    await _pumpUntilFound(tester, find.text('Agenda Checklist'));
    await tester.tap(find.text('Lanjut'));
    await _pumpUntilFound(tester, find.textContaining('Di tab Jadwal'));
    await tester.tap(find.text('Sebelumnya'));
    await _pumpUntilFound(tester, find.text('Agenda Checklist'));

    await tester.tap(find.text('Lewati'));
    await _pumpUntilFound(tester, find.text('Lewati tutorial?'));
    await tester.tap(find.text('Batal'));
    await _pumpUntilFound(tester, find.text('Agenda Checklist'));

    await tester.tap(find.text('Lewati'));
    await _pumpUntilFound(tester, find.text('Lewati tutorial?'));
    await tester.tap(find.text('Lewati Tutorial'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(await repository.isGuidedTutorialCompleted(), isTrue);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Settings can launch guided tutorial again', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ScheduleRepository(database);
    await repository.seedDefaultDataIfNeeded();
    await repository.completeGuidedTutorial();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const DailyScheduleApp(),
      ),
    );
    await _pumpUntilFound(tester, find.text('Hari Ini'));

    await tester.tap(find.text('Setelan'));
    await _pumpUntilFound(tester, find.text('Tampilkan Tutorial Lagi'));
    await tester.tap(find.text('Tampilkan Tutorial Lagi'));
    await _pumpUntilFound(tester, find.textContaining('Ini halaman utama'));

    expect(tester.takeException(), isNull);
  });
  testWidgets('Schedule form can open and close without lifecycle assertions',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ScheduleRepository(database);
    await repository.seedDefaultDataIfNeeded();
    await repository.completeGuidedTutorial();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const DailyScheduleApp(),
      ),
    );
    await _pumpUntilFound(tester, find.text('Hari Ini'));

    await tester.tap(find.text('Jadwal'));
    await _pumpUntilFound(tester, find.text('Tambah'));

    await tester.tap(find.text('Tambah'));
    await _pumpUntilFound(tester, find.text('Tambah Data'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Tambah Data'), findsOneWidget);
    expect(find.text('Tambah Hari / Mode Baru'), findsOneWidget);
    expect(find.text('Tambah Jadwal Baru'), findsOneWidget);
    await tester.tap(find.text('Tambah Hari / Mode Baru'));
    await _pumpUntilFound(tester, find.text('Tambah Mode Hari'));
    await tester.tap(find.text('Batal'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Tambah'));
    await _pumpUntilFound(tester, find.text('Tambah Data'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Tambah Hari / Mode Baru'));
    await _pumpUntilFound(tester, find.text('Tambah Mode Hari'));
    await tester.tapAt(const Offset(20, 20));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Tambah'));
    await _pumpUntilFound(tester, find.text('Tambah Data'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Tambah Hari / Mode Baru'));
    await _pumpUntilFound(tester, find.text('Tambah Mode Hari'));
    await tester.enterText(find.byType(TextFormField).last, 'Mode Test');
    await tester.tap(find.text('Tambah Mode'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Tambah'));
    await _pumpUntilFound(tester, find.text('Tambah Data'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tapAt(const Offset(20, 20));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Daily Schedule (example)').first);
    await tester.pump(const Duration(milliseconds: 500));
    await _pumpUntilFound(tester, find.byType(PopupMenuButton<String>));

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await _pumpUntilFound(tester, find.text('Edit'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Edit').last);
    await _pumpUntilFound(tester, find.text('Pengingat Jadwal'));
    expect(find.text('Pilih hari untuk jadwal'), findsOneWidget);
    expect(find.text('Aktifkan Pengingat'), findsOneWidget);
    expect(find.text('Notifikasi biasa'), findsOneWidget);
    expect(find.text('Aktif'), findsNothing);

    await tester.enterText(find.byType(TextFormField).last, 'Ujian');
    final addCategoryButton = find.byTooltip('Tambah kategori custom');
    await tester.scrollUntilVisible(
      addCategoryButton,
      200,
      scrollable: find.byType(Scrollable).last,
      maxScrolls: 20,
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(addCategoryButton);
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      find.descendant(
        of: find.byType(FilterChip),
        matching: find.text('Ujian'),
      ),
      findsOneWidget,
    );

    await tester.tapAt(const Offset(20, 20));
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxPumps = 100,
}) async {
  for (var i = 0; i < maxPumps; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  expect(finder, findsWidgets);
}
