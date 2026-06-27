import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class ScheduleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get description => text().nullable()();
  TextColumn get startTime => text().withLength(min: 5, max: 5)();
  TextColumn get endTime => text().withLength(min: 5, max: 5)();
  TextColumn get category => text().withLength(min: 1, max: 60)();
  TextColumn get scheduleMode => text().withLength(min: 1, max: 30)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get enableNotification =>
      boolean().withDefault(const Constant(true))();
  IntColumn get notifyBeforeMinutes =>
      integer().withDefault(const Constant(0))();
  TextColumn get reminderType =>
      text().withDefault(const Constant('notification'))();
  IntColumn get reminderOffsetMinutes =>
      integer().withDefault(const Constant(0))();
  TextColumn get alarmSound => text().withDefault(const Constant('default'))();
  BoolColumn get vibrate => boolean().withDefault(const Constant(true))();
  BoolColumn get enableAlarm => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class DailyChecklists extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get scheduleItemId => integer().references(ScheduleItems, #id)();
  TextColumn get date => text().withLength(min: 10, max: 10)(); // yyyy-MM-dd
  TextColumn get scheduleMode => text().withLength(min: 1, max: 30)();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  // Snapshot agar history lama tetap aman walau jadwal diedit/dinonaktifkan.
  TextColumn get snapshotTitle => text().withLength(min: 1, max: 120)();
  TextColumn get snapshotDescription => text().nullable()();
  TextColumn get snapshotStartTime => text().withLength(min: 5, max: 5)();
  TextColumn get snapshotEndTime => text().withLength(min: 5, max: 5)();
  TextColumn get snapshotCategory => text().withLength(min: 1, max: 60)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
        'UNIQUE(schedule_item_id, date, schedule_mode)',
      ];
}

class DailyModes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().withLength(min: 10, max: 10).unique()();
  TextColumn get scheduleMode => text().withLength(min: 1, max: 30)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().withLength(min: 1, max: 80).unique()();
  TextColumn get value => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
    tables: [ScheduleItems, DailyChecklists, DailyModes, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'daily_schedule'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(scheduleItems, scheduleItems.enableNotification);
            await m.addColumn(scheduleItems, scheduleItems.notifyBeforeMinutes);
          }
          if (from < 3) {
            await m.addColumn(scheduleItems, scheduleItems.reminderType);
            await m.addColumn(
                scheduleItems, scheduleItems.reminderOffsetMinutes);
            await m.addColumn(scheduleItems, scheduleItems.alarmSound);
            await m.addColumn(scheduleItems, scheduleItems.vibrate);
            await m.addColumn(scheduleItems, scheduleItems.enableAlarm);
          }
        },
      );
}
