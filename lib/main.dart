import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'database/app_database.dart';
import 'providers/app_providers.dart';
import 'repositories/schedule_repository.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  final repository = ScheduleRepository(database);
  await repository.seedDefaultDataIfNeeded();
  await NotificationService.instance.initialize();
  await NotificationService.instance.requestNotificationPermission();
  await NotificationService.instance.rescheduleTodayNotifications(repository);
  final initialThemeMode =
      await repository.getSetting('themeMode', 'light') == 'dark'
          ? ThemeMode.dark
          : ThemeMode.light;

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: DailyScheduleApp(initialThemeMode: initialThemeMode),
    ),
  );
}
