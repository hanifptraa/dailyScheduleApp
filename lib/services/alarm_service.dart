import 'notification_service.dart';

class AlarmService {
  const AlarmService(this._notificationService);

  final NotificationService _notificationService;

  Future<bool> hasAlarmPermission() {
    return _notificationService.hasReliableAlarmPermission();
  }

  Future<bool> requestAlarmPermission() {
    return _notificationService.requestAlarmPermission();
  }
}
