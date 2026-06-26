import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../database/app_database.dart';
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

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(
        _locationFromDeviceOffset(DateTime.now().timeZoneOffset));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
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

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.high,
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
    final status = await Permission.notification.status;
    return status.isGranted || status.isLimited;
  }

  Future<void> scheduleScheduleItemNotification({
    required ScheduleItem item,
    DateTime? date,
  }) async {
    await initialize();
    if (!item.isActive || !item.enableNotification) return;

    final targetDate = date ?? DateTime.now();
    final scheduledAt = _scheduledDateTime(item, targetDate);
    if (!scheduledAt.isAfter(DateTime.now())) return;

    await cancelScheduleItemNotification(item.id, date: targetDate);

    await _plugin.zonedSchedule(
      id: notificationIdFor(item.id, targetDate),
      title: 'Waktunya ${item.title}',
      body: 'Mulai ${item.startTime} - ${item.endTime}',
      scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      payload: 'schedule:${item.id}:${AppDateUtils.dateKey(targetDate)}',
    );
  }

  Future<void> cancelScheduleItemNotification(
    int scheduleItemId, {
    DateTime? date,
  }) async {
    await initialize();
    await _plugin.cancel(
        id: notificationIdFor(scheduleItemId, date ?? DateTime.now()));
  }

  Future<void> rescheduleTodayNotifications(
      ScheduleRepository repository) async {
    await initialize();
    await cancelTodayNotifications();
    if (!await hasNotificationPermission()) return;

    final today = DateTime.now();
    final dateKey = AppDateUtils.dateKey(today);
    final mode = await repository.getDailyMode(dateKey);
    final items = await repository.getActiveScheduleItems(mode);
    for (final item in items) {
      await scheduleScheduleItemNotification(item: item, date: today);
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
  }

  Future<void> cancelAllNotifications() async {
    await initialize();
    await _plugin.cancelAll();
  }

  int notificationIdFor(int scheduleItemId, DateTime date) {
    final dateKey = AppDateUtils.dateKey(date).replaceAll('-', '');
    final raw =
        int.tryParse('$dateKey${scheduleItemId % 10000}') ?? scheduleItemId;
    return raw & 0x7fffffff;
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
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    ).subtract(Duration(minutes: item.notifyBeforeMinutes));
  }
}
