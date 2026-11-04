import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/presentation/services/guest_notification_gateway.dart';
import 'package:budgets/features/guest/presentation/widgets/guest_notification_coordinator.dart';
import 'package:budgets/features/notifications/domain/models/notification_settings.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/fake_guest_notification_gateway.dart';

void main() {
  testWidgets('resume and preference changes refresh delivery; sync cancels it',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    addTearDown(guest.dispose);
    await guest.start();
    guest.markOnboardingComplete();
    final gateway = FakeGuestNotificationGateway()..granted = false;
    await tester.pumpWidget(ProviderScope(
        overrides: [
          guestNotificationGatewayProvider.overrideWithValue(gateway),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GuestNotificationCoordinator(
              guest: guest, child: const SizedBox()),
        )));
    await tester.pumpAndSettle();
    expect(gateway.reminders, isEmpty);
    gateway.granted = true;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(gateway.reminders, hasLength(1));
    await GuestPreferenceStore(database, guest.userId).setNotifications(
        NotificationSettings.defaults()
            .copyWith(reminderHour: 22, reminderMinute: 15));
    await tester.pumpAndSettle();
    expect(gateway.reminders.last.hour, 22);
    expect(gateway.reminders.last.minute, 15);
    final previousCancellations = gateway.cancellations;
    guest.setSyncing(true);
    await tester.pumpAndSettle();
    expect(gateway.cancellations, greaterThan(previousCancellations));
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
