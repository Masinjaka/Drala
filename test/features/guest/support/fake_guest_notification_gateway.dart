import 'package:budgets/features/guest/presentation/services/guest_notification_gateway.dart';
import 'package:budgets/features/notifications/domain/models/finance_notification.dart';

class FakeGuestNotificationGateway implements GuestNotificationGateway {
  bool granted = true;
  bool failDelivery = false;
  bool failSchedule = false;
  int requests = 0;
  int cancellations = 0;
  String zone = 'Indian/Antananarivo';
  final reminders = <({int hour, int minute, String zone, String title})>[];
  final alerts = <String>[];
  final bodies = <String>[];
  @override
  Future<bool> isGranted() async => granted;
  @override
  Future<bool> requestPermission() async {
    requests++;
    return granted;
  }

  @override
  Future<String> timezoneName() async => zone;
  @override
  Future<void> cancelReminder() async {
    cancellations++;
  }

  @override
  Future<void> scheduleReminder(
      {required int hour,
      required int minute,
      required String timezone,
      required String title,
      required String body}) async {
    if (failSchedule) throw StateError('Scheduling temporarily unavailable');
    reminders.add((hour: hour, minute: minute, zone: timezone, title: title));
  }

  @override
  Future<void> showAlert(
      FinanceNotification alert, String title, String body) async {
    if (failDelivery) throw StateError('Device temporarily unavailable');
    alerts.add(alert.id);
    bodies.add(body);
  }
}
