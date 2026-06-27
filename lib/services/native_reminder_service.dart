import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeReminderService {
  const NativeReminderService._();

  static const _channel = MethodChannel('daily_schedule/native_reminders');

  static bool get isSupported => !kIsWeb && Platform.isAndroid;

  static Future<bool> canScheduleExact() async {
    if (!isSupported) return true;
    try {
      return await _channel.invokeMethod<bool>('canScheduleExact') ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> requestExactAlarmPermission() async {
    if (!isSupported) return true;
    try {
      return await _channel.invokeMethod<bool>('requestExactAlarmPermission') ??
          false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> isIgnoringBatteryOptimizations() async {
    if (!isSupported) return true;
    try {
      return await _channel.invokeMethod<bool>(
            'isIgnoringBatteryOptimizations',
          ) ??
          false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> canUseFullScreenIntent() async {
    if (!isSupported) return true;
    try {
      return await _channel.invokeMethod<bool>('canUseFullScreenIntent') ??
          true;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> hasBackgroundStartPermission() async {
    if (!isSupported) return true;
    try {
      return await _channel
              .invokeMethod<bool>('hasBackgroundStartPermission') ??
          false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> requestIgnoreBatteryOptimizations() async {
    if (!isSupported) return true;
    try {
      return await _channel.invokeMethod<bool>(
            'requestIgnoreBatteryOptimizations',
          ) ??
          false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> requestBackgroundStartPermission() async {
    if (!isSupported) return true;
    try {
      return await _channel.invokeMethod<bool>(
            'requestBackgroundStartPermission',
          ) ??
          false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required bool ring,
    required bool vibrate,
    required String alarmSound,
  }) async {
    if (!isSupported) return false;
    try {
      return await _channel.invokeMethod<bool>('schedule', {
            'id': id,
            'title': title,
            'body': body,
            'triggerAtMillis': scheduledAt.millisecondsSinceEpoch,
            'ring': ring,
            'vibrate': vibrate,
            'alarmSound': alarmSound,
          }) ??
          false;
    } on PlatformException {
      return false;
    }
  }

  static Future<void> cancel(int id) async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod<bool>('cancel', {'id': id});
    } on PlatformException {
      return;
    }
  }

  static Future<void> cancelAll() async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod<bool>('cancelAll');
    } on PlatformException {
      return;
    }
  }
}
