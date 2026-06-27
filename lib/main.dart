import 'dart:async';
import 'dart:ui' as ui;

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
  final initialThemeMode =
      ui.PlatformDispatcher.instance.platformBrightness == ui.Brightness.dark
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

  unawaited(_prepareAppStartup(repository));
}

Future<void> _prepareAppStartup(ScheduleRepository repository) async {
  await repository.seedDefaultDataIfNeeded();
  await NotificationService.instance.initialize();
  await NotificationService.instance.rescheduleTodayNotifications(repository);
}
