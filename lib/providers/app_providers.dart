import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/schedule_mode.dart';
import '../models/today_models.dart';
import '../repositories/schedule_repository.dart';
import '../utils/date_utils.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider harus dioverride di main.dart');
});

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository(ref.watch(databaseProvider));
});

final navigationIndexProvider = NotifierProvider<NavigationIndexNotifier, int>(
  NavigationIndexNotifier.new,
);

class NavigationIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final settingsProvider = FutureProvider<Map<String, String>>((ref) async {
  return ref.watch(scheduleRepositoryProvider).getSettings();
});

final themeModeProvider = FutureProvider<ThemeMode>((ref) async {
  final settings = await ref.watch(settingsProvider.future);
  final value = settings['themeMode'] ?? 'system';
  return switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
});

final todayDataProvider = FutureProvider<TodayData>((ref) async {
  return ref.watch(scheduleRepositoryProvider).getTodayData(DateTime.now());
});

final todayModeProvider = FutureProvider<ScheduleModeType>((ref) async {
  final key = AppDateUtils.dateKey(DateTime.now());
  return ref.watch(scheduleRepositoryProvider).getDailyMode(key);
});

final scheduleModeFilterProvider =
    NotifierProvider<ScheduleModeFilterNotifier, ScheduleModeType>(
  ScheduleModeFilterNotifier.new,
);

class ScheduleModeFilterNotifier extends Notifier<ScheduleModeType> {
  @override
  ScheduleModeType build() => ScheduleModeType.regular;

  void setMode(ScheduleModeType mode) {
    state = mode;
  }
}

final scheduleItemsProvider = FutureProvider<List<ScheduleItem>>((ref) async {
  final mode = ref.watch(scheduleModeFilterProvider);
  return ref.watch(scheduleRepositoryProvider).getActiveScheduleItems(mode);
});

final historyProvider = FutureProvider<List<HistoryDayData>>((ref) async {
  return ref.watch(scheduleRepositoryProvider).getHistory();
});

final statisticsProvider = FutureProvider<StatisticsData>((ref) async {
  return ref.watch(scheduleRepositoryProvider).getStatistics();
});

void refreshMainProviders(WidgetRef ref) {
  ref.invalidate(todayDataProvider);
  ref.invalidate(todayModeProvider);
  ref.invalidate(scheduleItemsProvider);
  ref.invalidate(historyProvider);
  ref.invalidate(statisticsProvider);
  ref.invalidate(settingsProvider);
  ref.invalidate(themeModeProvider);
}
