import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../models/schedule_mode.dart';
import '../models/today_models.dart';
import '../repositories/schedule_repository.dart';
import '../services/notification_service.dart';
import '../utils/date_utils.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider harus dioverride di main.dart');
});

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository(ref.watch(databaseProvider));
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

final notificationPermissionProvider = FutureProvider<bool>((ref) async {
  return ref.watch(notificationServiceProvider).hasNotificationPermission();
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
  final value = settings['themeMode'] ?? 'light';
  return value == 'dark' ? ThemeMode.dark : ThemeMode.light;
});

final scheduleModesProvider =
    FutureProvider<List<ScheduleModeOption>>((ref) async {
  return ref.watch(scheduleRepositoryProvider).getScheduleModes();
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(scheduleRepositoryProvider).getCategories();
});

final todayDataProvider = FutureProvider<TodayData>((ref) async {
  return ref.watch(scheduleRepositoryProvider).getTodayData(DateTime.now());
});

final todayModeProvider = FutureProvider<ScheduleModeOption>((ref) async {
  final key = AppDateUtils.dateKey(DateTime.now());
  return ref.watch(scheduleRepositoryProvider).getDailyMode(key);
});

final scheduleModeFilterProvider =
    NotifierProvider<ScheduleModeFilterNotifier, ScheduleModeOption>(
  ScheduleModeFilterNotifier.new,
);

class ScheduleModeFilterNotifier extends Notifier<ScheduleModeOption> {
  @override
  ScheduleModeOption build() => ScheduleModeOption.regular;

  void setMode(ScheduleModeOption mode) {
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
  ref.invalidate(scheduleModesProvider);
  ref.invalidate(categoriesProvider);
  ref.invalidate(historyProvider);
  ref.invalidate(statisticsProvider);
  ref.invalidate(settingsProvider);
  ref.invalidate(themeModeProvider);
  ref.invalidate(notificationPermissionProvider);
}
