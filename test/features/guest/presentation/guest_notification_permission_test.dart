import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/presentation/pages/guest_notification_settings_page.dart';
import 'package:budgets/features/guest/presentation/services/guest_notification_gateway.dart';
import 'package:budgets/features/notifications/domain/models/notification_settings.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_guest_notification_gateway.dart';

void main() {
  testWidgets('denied system permission preserves the disabled preference',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    addTearDown(guest.dispose);
    await guest.start();
    final store = GuestPreferenceStore(database, guest.userId);
    await store.setNotifications(
        NotificationSettings.defaults().copyWith(notificationsEnabled: false));
    final gateway = FakeGuestNotificationGateway()..granted = false;
    await tester.pumpWidget(ProviderScope(
        overrides: [
          guestSessionProvider.overrideWithValue(guest),
          guestNotificationGatewayProvider.overrideWithValue(gateway),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const GuestNotificationSettingsPage(),
        )));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow notifications'));
    await tester.pumpAndSettle();
    expect(gateway.requests, 1);
    expect((await store.notifications()).notificationsEnabled, isFalse);
    expect(find.text('Daily reminders'), findsNothing);
    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10n.notificationsBlockedMessage), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
