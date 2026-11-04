import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'guest_notification_gateway.dart';
import 'guest_reminder_clock.dart';

class DeviceGuestNotificationGateway implements GuestNotificationGateway {
  final _plugin = FlutterLocalNotificationsPlugin();
  static const _reminderId = 900001;
  static bool _timezoneInitialized = false;
  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'budgets_notifications',
      'Drala Notifications',
      channelDescription: 'Notifications for reminders and budget warnings',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
    ),
    iOS: DarwinNotificationDetails(),
  );

  AndroidFlutterLocalNotificationsPlugin? get _android => kIsWeb
      ? null
      : _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  IOSFlutterLocalNotificationsPlugin? get _ios => kIsWeb
      ? null
      : _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

  @override
  Future<bool> isGranted() async =>
      await _android?.areNotificationsEnabled() ??
      (await _ios?.checkPermissions())?.isEnabled ??
      false;

  @override
  Future<bool> requestPermission() async =>
      await _android?.requestNotificationsPermission() ??
      await _ios?.requestPermissions(alert: true, badge: true, sound: true) ??
      false;

  @override
  Future<String> timezoneName() async =>
      (await FlutterTimezone.getLocalTimezone()).identifier;

  @override
  Future<void> scheduleReminder({
    required int hour,
    required int minute,
    required String timezone,
    required String title,
    required String body,
  }) async {
    if (!_timezoneInitialized) {
      tz_data.initializeTimeZones();
      _timezoneInitialized = true;
    }
    await _plugin.zonedSchedule(
      id: _reminderId,
      title: title,
      body: body,
      scheduledDate: GuestReminderClock.next(
        tz.getLocation(timezone),
        DateTime.now(),
        hour,
        minute,
      ),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'guest:reminder',
    );
  }

  @override
  Future<void> cancelReminder() async {
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      await _plugin.cancel(id: _reminderId);
    }
  }

  @override
  Future<void> showAlert(
          FinanceNotification alert, String title, String body) =>
      _plugin.show(
        // Stable across process restarts; retries replace the same notification.
        id: alert.id.codeUnits.fold<int>(2166136261,
                (hash, unit) => ((hash ^ unit) * 16777619) & 0x3fffffff) |
            0x40000000,
        title: title,
        body: body,
        notificationDetails: _details,
        payload: 'guest:${alert.id}',
      );
}
