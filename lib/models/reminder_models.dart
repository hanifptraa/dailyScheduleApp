class ReminderType {
  const ReminderType._(this.value, this.label);

  final String value;
  final String label;

  static const notification =
      ReminderType._('notification', 'Notifikasi biasa');
  static const alarm = ReminderType._('alarm', 'Alarm berbunyi');
  static const values = [notification, alarm];

  static ReminderType fromValue(String? value) {
    return values.firstWhere(
      (item) => item.value == value,
      orElse: () => notification,
    );
  }
}

class AlarmSoundOption {
  const AlarmSoundOption._(this.value, this.label);

  final String value;
  final String label;

  static const systemDefault = AlarmSoundOption._('default', 'Default');
  static const gentle = AlarmSoundOption._('gentle', 'Lembut');
  static const focus = AlarmSoundOption._('focus', 'Fokus');
  static const strong = AlarmSoundOption._('strong', 'Alarm kuat');
  static const values = [systemDefault, gentle, focus, strong];

  static AlarmSoundOption fromValue(String? value) {
    return values.firstWhere(
      (item) => item.value == value,
      orElse: () => systemDefault,
    );
  }
}

class ReminderOffsetOption {
  const ReminderOffsetOption(this.minutes, this.label);

  final int minutes;
  final String label;

  static const values = [
    ReminderOffsetOption(0, 'Tepat saat mulai'),
    ReminderOffsetOption(5, '5 menit sebelumnya'),
    ReminderOffsetOption(10, '10 menit sebelumnya'),
  ];

  static ReminderOffsetOption fromMinutes(int minutes) {
    return values.firstWhere(
      (item) => item.minutes == minutes,
      orElse: () => values.first,
    );
  }
}

enum ReminderScheduleResult {
  skipped,
  scheduledNotification,
  scheduledAlarm,
  fallbackNotification,
  missingNotificationPermission,
  failed,
}
