import '../database/app_database.dart';
import 'schedule_mode.dart';

class TodayScheduleEntry {
  const TodayScheduleEntry({
    required this.item,
    required this.checklist,
  });

  final ScheduleItem item;
  final DailyChecklist? checklist;

  bool get isDone => checklist?.isDone ?? false;
}

class TodayData {
  const TodayData({
    required this.dateKey,
    required this.mode,
    required this.entries,
  });

  final String dateKey;
  final ScheduleModeType mode;
  final List<TodayScheduleEntry> entries;

  int get total => entries.length;
  int get done => entries.where((entry) => entry.isDone).length;
  int get percent => total == 0 ? 0 : ((done / total) * 100).round();
  double get progress => total == 0 ? 0 : done / total;
}

class HistoryDayData {
  const HistoryDayData({
    required this.dateKey,
    required this.mode,
    required this.total,
    required this.done,
    required this.items,
  });

  final String dateKey;
  final ScheduleModeType mode;
  final int total;
  final int done;
  final List<DailyChecklist> items;

  int get percent => total == 0 ? 0 : ((done / total) * 100).round();
  String get status => productivityStatus(percent);
}

class StatisticsData {
  const StatisticsData({
    required this.todayPercent,
    required this.last7Average,
    required this.productiveDays,
    required this.streak,
    required this.mostDoneCategory,
    required this.mostMissedCategory,
  });

  final int todayPercent;
  final int last7Average;
  final int productiveDays;
  final int streak;
  final String mostDoneCategory;
  final String mostMissedCategory;
}
