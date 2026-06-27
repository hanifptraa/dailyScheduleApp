import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../database/app_database.dart';
import '../models/reminder_models.dart';
import 'native_reminder_service.dart';
import '../repositories/schedule_repository.dart';
import '../utils/date_utils.dart';
import '../utils/time_utils.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'schedule_reminders';
  static const _channelName = 'Pengingat Jadwal';
  static const _channelDescription =
      'Notifikasi pengingat berdasarkan jadwal harian.';

  static const _alarmChannelId = 'schedule_alarms_v2';
  static const _alarmChannelName = 'Alarm Jadwal';
  static const _alarmChannelDescription =
      'Alarm berbunyi untuk pengingat jadwal penting.';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(
        _locationFromDeviceOffset(DateTime.now().timeZoneOffset));

    const androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      ),
    );

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _alarmChannelId,
        _alarmChannelName,
        description: _alarmChannelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
    );

    _initialized = true;
  }

  Future<bool> requestNotificationPermission() async {
    await initialize();
    if (kIsWeb) return true;

    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final result = await android?.requestNotificationsPermission();
      if (result != null) return result;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final iosResult = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (iosResult != null) return iosResult;

      final mac = _plugin.resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>();
      final macResult = await mac?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (macResult != null) return macResult;
    }

    final status = await Permission.notification.request();
    return status.isGranted || status.isLimited;
  }

  Future<bool> hasNotificationPermission() async {
    await initialize();
    if (kIsWeb) return true;
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final enabled = await android?.areNotificationsEnabled();
      if (enabled != null) return enabled;
    }
    final status = await Permission.notification.status;
    return status.isGranted || status.isLimited;
  }

  Future<bool> requestAlarmPermission() async {
    await initialize();
    if (kIsWeb || !Platform.isAndroid) return true;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (!await hasAlarmPermission()) {
      await NativeReminderService.requestExactAlarmPermission();
      await android?.requestExactAlarmsPermission();
      return hasReliableAlarmPermission();
    }

    if (!await NativeReminderService.canUseFullScreenIntent()) {
      await android?.requestFullScreenIntentPermission();
      return hasReliableAlarmPermission();
    }

    if (!await NativeReminderService.isIgnoringBatteryOptimizations()) {
      await NativeReminderService.requestIgnoreBatteryOptimizations();
      return hasReliableAlarmPermission();
    }

    if (!await NativeReminderService.hasBackgroundStartPermission()) {
      await NativeReminderService.requestBackgroundStartPermission();
      return hasReliableAlarmPermission();
    }

    return true;
  }

  Future<bool> hasAlarmPermission() async {
    await initialize();
    if (kIsWeb || !Platform.isAndroid) return true;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final nativeAllowed = await NativeReminderService.canScheduleExact();
    final pluginAllowed = await android?.canScheduleExactNotifications();
    return nativeAllowed && (pluginAllowed ?? nativeAllowed);
  }

  Future<bool> hasReliableAlarmPermission() async {
    if (!await hasAlarmPermission()) return false;
    if (kIsWeb || !Platform.isAndroid) return true;
    final canUseFullScreen =
        await NativeReminderService.canUseFullScreenIntent();
    final ignoresBattery =
        await NativeReminderService.isIgnoringBatteryOptimizations();
    final backgroundReady =
        await NativeReminderService.hasBackgroundStartPermission();
    return canUseFullScreen && ignoresBattery && backgroundReady;
  }

  Future<ReminderScheduleResult> scheduleScheduleItemReminder({
    required ScheduleItem item,
    DateTime? date,
  }) async {
    await initialize();
    if (!item.isActive || !item.enableNotification) {
      return ReminderScheduleResult.skipped;
    }
    if (!await hasNotificationPermission()) {
      return ReminderScheduleResult.missingNotificationPermission;
    }

    final wantsAlarm =
        item.reminderType == ReminderType.alarm.value && item.enableAlarm;
    if (wantsAlarm) {
      if (await hasAlarmPermission()) {
        final alarmScheduled = await _scheduleAlarm(item: item, date: date);
        if (alarmScheduled) return ReminderScheduleResult.scheduledAlarm;
      }

      final fallbackScheduled =
          await _scheduleNotification(item: item, date: date);
      return fallbackScheduled
          ? ReminderScheduleResult.fallbackNotification
          : ReminderScheduleResult.failed;
    }

    final notificationScheduled =
        await _scheduleNotification(item: item, date: date);
    return notificationScheduled
        ? ReminderScheduleResult.scheduledNotification
        : ReminderScheduleResult.failed;
  }

  Future<void> scheduleScheduleItemNotification({
    required ScheduleItem item,
    DateTime? date,
  }) async {
    await _scheduleNotification(item: item, date: date);
  }

  Future<bool> _scheduleNotification({
    required ScheduleItem item,
    DateTime? date,
  }) async {
    await initialize();
    if (!item.isActive || !item.enableNotification) return false;

    final targetDate = date ?? DateTime.now();
    final scheduledAt = _scheduledDateTime(item, targetDate);
    if (!scheduledAt.isAfter(DateTime.now())) return false;

    await cancelScheduleItemNotification(item.id, date: targetDate);

    if (NativeReminderService.isSupported &&
        await NativeReminderService.canScheduleExact()) {
      final scheduled = await NativeReminderService.schedule(
        id: notificationIdFor(item.id, targetDate),
        title: 'Waktunya ${item.title}',
        body: 'Mulai ${item.startTime} - ${item.endTime}',
        scheduledAt: scheduledAt,
        ring: false,
        vibrate: item.vibrate,
        alarmSound: 'default',
      );
      if (scheduled) return true;
    }

    try {
      await _plugin.zonedSchedule(
        id: notificationIdFor(item.id, targetDate),
        title: 'Waktunya ${item.title}',
        body: 'Mulai ${item.startTime} - ${item.endTime}',
        scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
        androidScheduleMode: await hasAlarmPermission()
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            category: AndroidNotificationCategory.reminder,
            enableVibration: item.vibrate,
          ),
          iOS: const DarwinNotificationDetails(),
          macOS: const DarwinNotificationDetails(),
        ),
        payload: 'schedule:${item.id}:${AppDateUtils.dateKey(targetDate)}',
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _scheduleAlarm({
    required ScheduleItem item,
    DateTime? date,
  }) async {
    await initialize();
    if (!item.isActive || !item.enableNotification) return false;

    final targetDate = date ?? DateTime.now();
    final scheduledAt = _scheduledDateTime(item, targetDate);
    if (!scheduledAt.isAfter(DateTime.now())) return false;

    await cancelScheduleItemNotification(item.id, date: targetDate);

    if (NativeReminderService.isSupported &&
        await NativeReminderService.canScheduleExact()) {
      final scheduled = await NativeReminderService.schedule(
        id: alarmIdFor(item.id, targetDate),
        title: 'Alarm: ${item.title}',
        body: 'Mulai ${item.startTime} - ${item.endTime}',
        scheduledAt: scheduledAt,
        ring: true,
        vibrate: item.vibrate,
        alarmSound: item.alarmSound,
      );
      if (scheduled) return true;
    }

    try {
      await _plugin.zonedSchedule(
        id: alarmIdFor(item.id, targetDate),
        title: 'Alarm: ${item.title}',
        body: 'Mulai ${item.startTime} - ${item.endTime}',
        scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _alarmChannelId,
            _alarmChannelName,
            channelDescription: _alarmChannelDescription,
            importance: Importance.max,
            priority: Priority.max,
            category: AndroidNotificationCategory.alarm,
            fullScreenIntent: true,
            enableVibration: item.vibrate,
            audioAttributesUsage: AudioAttributesUsage.alarm,
            ongoing: true,
          ),
          iOS: const DarwinNotificationDetails(
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
          macOS: const DarwinNotificationDetails(),
        ),
        payload: 'alarm:${item.id}:${AppDateUtils.dateKey(targetDate)}',
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> cancelScheduleItemNotification(
    int scheduleItemId, {
    DateTime? date,
  }) async {
    await initialize();
    final targetDate = date ?? DateTime.now();
    final notificationId = notificationIdFor(scheduleItemId, targetDate);
    final alarmId = alarmIdFor(scheduleItemId, targetDate);
    await _plugin.cancel(id: notificationId);
    await _plugin.cancel(id: alarmId);
    await NativeReminderService.cancel(notificationId);
    await NativeReminderService.cancel(alarmId);
  }

  Future<void> rescheduleTodayNotifications(
      ScheduleRepository repository) async {
    await rescheduleTodayReminders(repository);
  }

  Future<void> rescheduleTodayReminders(ScheduleRepository repository) async {
    await initialize();
    if (!await hasNotificationPermission()) return;
    await cancelTodayNotifications();

    final today = DateTime.now();
    final dateKey = AppDateUtils.dateKey(today);
    final mode = await repository.getDailyMode(dateKey);
    final items = await repository.getActiveScheduleItems(mode);
    for (final item in items) {
      await scheduleScheduleItemReminder(item: item, date: today);
    }
  }

  Future<void> cancelTodayNotifications() async {
    await initialize();
    final todayKey = AppDateUtils.dateKey(DateTime.now());
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.payload?.endsWith(':$todayKey') ?? false) {
        await _plugin.cancel(id: request.id);
      }
    }
    await NativeReminderService.cancelAll();
  }

  Future<void> cancelAllNotifications() async {
    await initialize();
    await _plugin.cancelAll();
    await NativeReminderService.cancelAll();
  }

  int notificationIdFor(int scheduleItemId, DateTime date) {
    final dateKey = AppDateUtils.dateKey(date).replaceAll('-', '');
    final raw =
        int.tryParse('$dateKey${scheduleItemId % 10000}') ?? scheduleItemId;
    return raw & 0x3fffffff;
  }

  int alarmIdFor(int scheduleItemId, DateTime date) {
    return notificationIdFor(scheduleItemId, date) | 0x40000000;
  }

  tz.Location _locationFromDeviceOffset(Duration offset) {
    final hours = offset.inHours;
    final locationName = switch (hours) {
      7 => 'Asia/Jakarta',
      8 => 'Asia/Makassar',
      9 => 'Asia/Jayapura',
      _ => 'Asia/Jakarta',
    };
    return tz.getLocation(locationName);
  }

  DateTime _scheduledDateTime(ScheduleItem item, DateTime date) {
    final time = AppTimeUtils.toTimeOfDay(item.startTime);
    final offsetMinutes = item.reminderType == ReminderType.alarm.value
        ? item.reminderOffsetMinutes
        : item.notifyBeforeMinutes;
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    ).subtract(Duration(minutes: offsetMinutes));
  }
}
