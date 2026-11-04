import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_notification_repository.dart';
import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/presentation/services/guest_notification_delivery.dart';
import 'package:budgets/features/notifications/domain/models/notification_settings.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/fake_guest_notification_gateway.dart';

void main() {
  late GuestDatabase database;
  late GuestSession guest;
  late GuestPreferenceStore preferences;
  late FakeGuestNotificationGateway gateway;
  late GuestNotificationDelivery delivery;
  final en = lookupAppLocalizations(const Locale('en'));
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    database = GuestDatabase(NativeDatabase.memory());
    guest = await GuestSession.load(database);
    await guest.start();
    guest.markOnboardingComplete();
    preferences = GuestPreferenceStore(database, guest.userId);
    gateway = FakeGuestNotificationGateway();
    delivery = GuestNotificationDelivery(guest, gateway);
    await database.customInsert('''INSERT INTO guest_notifications
      (id,user_id,envelope_id,transaction_id,notification_type,envelope_name,amount,period_month,created_at)
      VALUES('alert',?,'food','entry','envelope_near_limit','Food',90,'2026-10-01','2026-10-22')''',
        variables: [Variable.withString(guest.userId)]);
  });
  tearDown(() async {
    guest.dispose();
    await database.close();
  });

  test('schedules saved clock time and language without redundant rescheduling',
      () async {
    await preferences.setNotifications(NotificationSettings.defaults()
        .copyWith(reminderHour: 21, reminderMinute: 30));
    await delivery.sync(en);
    await delivery.sync(en);
    expect(gateway.reminders, hasLength(1));
    expect(gateway.reminders.single.hour, 21);
    expect(gateway.reminders.single.minute, 30);
    expect(gateway.alerts, ['alert']);
    expect(gateway.bodies.single, en.envelopeBudgetAlmostReached('Food'));
    expect(await GuestNotificationRepository(database, guest.userId).pending(),
        isEmpty);
    expect(
        (await GuestNotificationRepository(database, guest.userId)
                .notifications())
            .single
            .isRead,
        isFalse);
    gateway.zone = 'Europe/Berlin';
    await delivery.sync(en);
    expect(gateway.reminders.last.zone, 'Europe/Berlin');
    await delivery.sync(lookupAppLocalizations(const Locale('mg')));
    expect(gateway.reminders.last.title, 'Fampahatsiahivana isan’andro');
    expect(gateway.reminders, hasLength(3));
  });

  test(
      'denied permission cancels stale reminder without prompting or discarding alerts',
      () async {
    gateway.granted = false;
    await delivery.sync(en);
    expect(gateway.requests, 0);
    expect(gateway.cancellations, 1);
    expect(gateway.alerts, isEmpty);
    expect(await GuestNotificationRepository(database, guest.userId).pending(),
        hasLength(1));
    gateway.granted = true;
    await delivery.sync(en);
    expect(gateway.alerts, ['alert']);
  });

  test('reminder scheduling failure does not prevent budget alert delivery',
      () async {
    gateway.failSchedule = true;
    await expectLater(delivery.sync(en), throwsStateError);
    expect(gateway.alerts, ['alert']);
    gateway.failSchedule = false;
    await delivery.sync(en);
    expect(gateway.reminders, hasLength(1));
    expect(gateway.alerts, ['alert']);
  });

  test('failed native delivery leaves outbox pending for retry', () async {
    gateway.failDelivery = true;
    await expectLater(delivery.sync(en), throwsStateError);
    expect(await GuestNotificationRepository(database, guest.userId).pending(),
        hasLength(1));
    gateway.failDelivery = false;
    await delivery.sync(en);
    await delivery.sync(en);
    expect(gateway.alerts, ['alert']);
  });

  test('disabled preferences suppress delivery and cancel existing reminder',
      () async {
    await preferences.setNotifications(
        NotificationSettings.defaults().copyWith(notificationsEnabled: false));
    await delivery.sync(en);
    expect(gateway.reminders, isEmpty);
    expect(gateway.alerts, isEmpty);
    expect(gateway.cancellations, 1);
  });

  test('syncing or inactive guests cancel local reminders and do not deliver',
      () async {
    guest.setSyncing(true);
    await delivery.sync(en);
    guest.setSyncing(false);
    guest.isActive = false;
    await delivery.sync(en);
    expect(gateway.cancellations, 2);
    expect(gateway.reminders, isEmpty);
    expect(gateway.alerts, isEmpty);
  });
}
