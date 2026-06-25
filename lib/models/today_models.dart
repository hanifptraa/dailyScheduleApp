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
  final ScheduleModeOption mode;
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
  final ScheduleModeOption mode;
  final int total;
  final int done;
  final List<DailyChecklist> items;

  int get percent => total == 0 ? 0 : ((done / total) * 100).round();
  String get status => productivityStatus(percent);
}

class TrendPoint {
  const TrendPoint({
    required this.dateKey,
    required this.percent,
    required this.done,
    required this.total,
  });

  final String dateKey;
  final int percent;
  final int done;
  final int total;
}

class CategoryPerformance {
  const CategoryPerformance({
    required this.category,
    required this.done,
    required this.total,
  });

  final String category;
  final int done;
  final int total;

  int get percent => total == 0 ? 0 : ((done / total) * 100).round();
}

class StatisticsData {
  const StatisticsData({
    required this.todayPercent,
    required this.last7Average,
    required this.productiveDays,
    required this.streak,
    required this.mostDoneCategory,
    required this.mostMissedCategory,
    required this.totalTasks,
    required this.completedTasks,
    required this.completionRate,
    required this.consistencyScore,
    required this.bestDayLabel,
    required this.bestDayPercent,
    required this.trend,
    required this.categories,
  });

  final int todayPercent;
  final int last7Average;
  final int productiveDays;
  final int streak;
  final String mostDoneCategory;
  final String mostMissedCategory;
  final int totalTasks;
  final int completedTasks;
  final int completionRate;
  final int consistencyScore;
  final String bestDayLabel;
  final int bestDayPercent;
  final List<TrendPoint> trend;
  final List<CategoryPerformance> categories;
}
