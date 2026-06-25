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
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await ScheduleRepository(database).seedDefaultDataIfNeeded();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const DailyScheduleApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Jadwal'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Jadwal'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
