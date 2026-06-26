import 'package:daily_schedule/app.dart';
import 'package:daily_schedule/database/app_database.dart';
import 'package:daily_schedule/providers/app_providers.dart';
import 'package:daily_schedule/repositories/schedule_repository.dart';
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
    expect(AppTimeUtils.isValidRange('10:00', '09:00'), isFalse);
  });

  testWidgets('Schedule form can open and close without lifecycle assertions',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await ScheduleRepository(database).seedDefaultDataIfNeeded();

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

    await tester.tap(find.text('Hari Biasa').first);
    await tester.pump(const Duration(milliseconds: 500));
    await _pumpUntilFound(tester, find.byType(PopupMenuButton<String>));

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await _pumpUntilFound(tester, find.text('Edit'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Edit').last);
    await _pumpUntilFound(tester, find.text('Pengingat Jadwal'));
    expect(find.text('Pilih hari untuk jadwal'), findsOneWidget);
    expect(find.text('Aktifkan Notifikasi'), findsOneWidget);

    await tester.tapAt(const Offset(20, 20));
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxPumps = 20,
}) async {
  for (var i = 0; i < maxPumps; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  expect(finder, findsWidgets);
}
