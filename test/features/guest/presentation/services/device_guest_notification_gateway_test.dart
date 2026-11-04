import 'package:budgets/features/guest/presentation/services/device_guest_notification_gateway.dart';
import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  const zoneChannel = MethodChannel('flutter_timezone');
  final calls = <MethodCall>[];
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return switch (call.method) {
        'areNotificationsEnabled' || 'requestNotificationsPermission' => true,
        _ => null,
      };
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            zoneChannel, (_) async => 'Indian/Antananarivo');
    calls.clear();
  });
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(zoneChannel, null);
  });

  test('native reminder uses zone, daily recurrence and inexact Android alarm',
      () async {
    final gateway = DeviceGuestNotificationGateway();
    expect(await gateway.isGranted(), isTrue);
    expect(await gateway.requestPermission(), isTrue);
    final zone = await gateway.timezoneName();
    await gateway.scheduleReminder(
        hour: 21,
        minute: 30,
        timezone: zone,
        title: 'Reminder',
        body: 'Record today');
    final arguments =
        calls.singleWhere((c) => c.method == 'zonedSchedule').arguments as Map;
    expect(arguments['timeZoneName'], zone);
    expect(arguments['scheduledDateTime'], contains('T21:30:00'));
    expect(arguments['matchDateTimeComponents'], DateTimeComponents.time.index);
    expect((arguments['platformSpecifics'] as Map)['scheduleMode'],
        'inexactAllowWhileIdle');
    await gateway.cancelReminder();
    expect((calls.last.arguments as Map)['id'], arguments['id']);
  });

  test('retried alert uses stable native id and guest payload', () async {
    final gateway = DeviceGuestNotificationGateway();
    final alert = FinanceNotification(
        id: 'alert-uuid',
        envelopeId: 'food',
        envelopeName: 'Food',
        amount: 5,
        periodMonth: DateTime(2026, 10),
        isRead: false,
        createdAt: DateTime(2026, 10, 22));
    await gateway.showAlert(alert, 'Drala', 'Budget');
    await DeviceGuestNotificationGateway().showAlert(alert, 'Drala', 'Budget');
    final shows = calls.where((c) => c.method == 'show').toList();
    final first = shows.first.arguments as Map;
    final last = shows.last.arguments as Map;
    expect(first['id'], last['id']);
    expect(first['id'], inInclusiveRange(0x40000000, 0x7fffffff));
    expect(first['payload'], 'guest:alert-uuid');
  });
}
