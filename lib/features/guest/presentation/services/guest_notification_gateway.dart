import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_guest_notification_gateway.dart';

abstract interface class GuestNotificationGateway {
  Future<bool> isGranted();
  Future<bool> requestPermission();
  Future<String> timezoneName();
  Future<void> scheduleReminder({
    required int hour,
    required int minute,
    required String timezone,
    required String title,
    required String body,
  });
  Future<void> cancelReminder();
  Future<void> showAlert(FinanceNotification alert, String title, String body);
}

final guestNotificationGatewayProvider = Provider<GuestNotificationGateway>(
  (ref) => DeviceGuestNotificationGateway(),
);
