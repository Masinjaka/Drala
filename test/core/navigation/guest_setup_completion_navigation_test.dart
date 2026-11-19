import 'dart:async';
import 'package:budgets/core/navigation/app_navigation.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/presentation/pages/guest_account_choice_page.dart';
import 'package:budgets/features/onboarding/presentation/pages/account_setup_page.dart';
import 'package:budgets/features/onboarding/presentation/pages/setup_complete_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('wallet setup goes through account choice directly to home',
      (tester) async {
    final guest = await _guest(tester);
    await guest.onboarding.save({
      'step': 5,
      'language': 'en',
      'currency': 'MGA',
      'categories': <String>[],
      'wallets': <String>[]
    });
    final navigation = await _app(tester, guest);
    expect(find.byType(AccountSetupPage), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(GuestAccountChoicePage), findsOneWidget);
    expect(find.byType(SetupCompletePage), findsNothing);
    expect(guest.onboardingComplete, isTrue);
    expect(guest.completionPending, isFalse);
    await tester.tap(find.text('Continue as guest'));
    await tester.pumpAndSettle();
    expect(navigation.router.routeInformationProvider.value.uri.path, '/home');
    expect(find.byType(SetupCompletePage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final synced in [false, true]) {
    testWidgets(
        'legacy completion flag does not interrupt home with synced=$synced',
        (tester) async {
      final guest = await _guest(tester);
      await guest.onboarding.complete(
          currency: 'MGA', language: 'en', categories: [], wallets: []);
      await guest.prepareCompletion();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('guest_completion_pending', true);
      await guest.markChoiceSeen();
      if (synced) await guest.stopAfterSync();
      final reloaded = await GuestSession.load(guest.database);
      final navigation = await _app(tester, reloaded, signedIn: synced);
      expect(
          navigation.router.routeInformationProvider.value.uri.path, '/home');
      expect(find.byType(SetupCompletePage), findsNothing);
      await reloaded.markCompletionSeen();
      expect(
          (await GuestSession.load(guest.database)).completionPending, isFalse);
      // Avoid constructing the real home destination in this routing test.
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}

Future<GuestSession> _guest(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final database = GuestDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  final guest = await GuestSession.load(database);
  await guest.start();
  return guest;
}

Future<AppNavigation> _app(WidgetTester tester, GuestSession guest,
    {bool signedIn = false}) async {
  final authChanges = StreamController<Object?>.broadcast();
  final navigation = AppNavigation(
      isSignedIn: () => signedIn,
      authChanges: authChanges.stream,
      guestSession: guest);
  addTearDown(() async {
    navigation.dispose();
    await authChanges.close();
  });
  await tester.pumpWidget(ProviderScope(
    overrides: [guestSessionProvider.overrideWithValue(guest)],
    child: MaterialApp.router(
        routerConfig: navigation.router,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales),
  ));
  await tester.pumpAndSettle();
  return navigation;
}
