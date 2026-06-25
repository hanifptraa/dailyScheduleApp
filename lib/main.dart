import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'database/app_database.dart';
import 'providers/app_providers.dart';
import 'repositories/schedule_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await ScheduleRepository(database).seedDefaultDataIfNeeded();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const DailyScheduleApp(),
    ),
  );
}
