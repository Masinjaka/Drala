import 'dart:async';
import 'package:budgets/core/navigation/app_navigation.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/home/presentation/pages/currency_home_page.dart';
import 'package:budgets/features/onboarding/presentation/pages/account_setup_page.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final restart in [false, true]) {
    testWidgets(
        'existing account opens Home with unfinished guest draft, restart=$restart',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final database = GuestDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final guest = await GuestSession.load(database);
      await guest.start();
      final changes = StreamController<Object?>.broadcast();
      var signedIn = restart;
      final navigation = AppNavigation(
          isSignedIn: () => signedIn,
          guestSession: guest,
          authChanges: changes.stream);
      addTearDown(() async {
        navigation.dispose();
        await changes.close();
      });
      await tester.pumpWidget(ProviderScope(overrides: [
        guestSessionProvider.overrideWithValue(guest),
      ], child: MaterialApp.router(routerConfig: navigation.router)));
      await tester.pumpAndSettle();
      if (!restart) {
        navigation.router.go('/login');
        await tester.pumpAndSettle();
        signedIn = true;
        changes.add(null);
        await tester.pumpAndSettle();
      }
      expect(
          navigation.router.routeInformationProvider.value.uri.path, '/home');
      expect(find.byType(CurrencyHomePage), findsOneWidget);
      expect(find.byType(AccountSetupPage), findsNothing);
      // Signup still explicitly opens setup for a newly created account.
      navigation.router.go('/onboarding');
      await tester.pumpAndSettle();
      expect(find.byType(AccountSetupPage), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
