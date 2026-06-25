import 'package:daily_schedule/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppTimeUtils converts and validates HH:mm values', () {
    expect(AppTimeUtils.toMinutes('08:30'), 510);
    expect(AppTimeUtils.fromTimeOfDay(const TimeOfDay(hour: 9, minute: 5)),
        '09:05');
    expect(AppTimeUtils.isValidRange('08:00', '09:00'), isTrue);
    expect(AppTimeUtils.isValidRange('10:00', '09:00'), isFalse);
  });
}
