import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/presentation/services/guest_notification_gateway.dart';
import '../support/fake_guest_notification_gateway.dart';
import 'package:budgets/features/guest/presentation/pages/guest_notification_settings_page.dart';
import 'package:budgets/features/notifications/domain/models/notification_settings.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('guest notification switches and reminder time persist locally',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    final store = GuestPreferenceStore(database, guest.userId);
    await store.setNotifications(NotificationSettings.defaults().copyWith(
        notificationsEnabled: false,
        remindersEnabled: false,
        warningsEnabled: false,
        reminderHour: 21,
        reminderMinute: 30));
    await tester.pumpWidget(ProviderScope(
      overrides: [
        guestSessionProvider.overrideWithValue(guest),
        guestNotificationGatewayProvider
            .overrideWithValue(FakeGuestNotificationGateway())
      ],
      child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!),
          home: const GuestNotificationSettingsPage()),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Daily reminders'), findsNothing);
    for (final label in [
      'Allow notifications',
      'Daily reminders',
      'Budget alerts'
    ]) {
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }
    var settings = await store.notifications();
    expect(settings.notificationsEnabled, isTrue);
    expect(settings.remindersEnabled, isTrue);
    expect(settings.warningsEnabled, isTrue);
    await tester.tap(find.text('Preferred reminder time'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CupertinoPicker).first, const Offset(0, -44));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('app-wheel-picker-done')));
    await tester.pumpAndSettle();
    settings = await store.notifications();
    expect(settings.reminderHour, 22);
    expect(settings.reminderMinute, 30);
    await tester.tap(find.text('Allow notifications'));
    await tester.pumpAndSettle();
    expect((await store.notifications()).notificationsEnabled, isFalse);
    expect(find.text('Daily reminders'), findsNothing);
  });
}
