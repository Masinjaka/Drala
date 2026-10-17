import 'dart:async';

import 'package:budgets/core/navigation/app_navigation.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/features/home/presentation/widgets/home_dashboard.dart';
import 'package:budgets/features/onboarding/presentation/pages/getting_started_page.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('ready guest after sign-out lands on Activities', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    final authChanges = StreamController<Object?>.broadcast();
    final navigation = AppNavigation(
      isSignedIn: () => false,
      authChanges: authChanges.stream,
      guestSession: guest,
    );
    addTearDown(() async {
      navigation.dispose();
      await authChanges.close();
    });
    await tester.pumpWidget(ProviderScope(
      overrides: [guestSessionProvider.overrideWithValue(guest)],
      child: MaterialApp.router(routerConfig: navigation.router),
    ));
    expect(find.byType(GettingStartedPage), findsOneWidget);

    await guest.enterAfterSignOut(currency: 'MGA', language: 'en');
    await tester.pumpAndSettle();

    expect(navigation.router.routeInformationProvider.value.uri.path, '/home');
    expect(find.byType(HomeDashboard), findsOneWidget);
    expect(
        tester
            .widget<HomeBottomNavigationBar>(
              find.byType(HomeBottomNavigationBar),
            )
            .selectedIndex,
        0);
  });

  testWidgets('sign-out refreshes never leave home during guest setup',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.enterAfterSignOut(currency: 'MGA', language: 'en');
    var signedIn = true;
    final authChanges = StreamController<Object?>.broadcast();
    final navigation = AppNavigation(
      isSignedIn: () => signedIn,
      authChanges: authChanges.stream,
      guestSession: guest,
    );
    addTearDown(() async {
      navigation.dispose();
      await authChanges.close();
      guest.dispose();
    });
    await tester.pumpWidget(ProviderScope(
      overrides: [guestSessionProvider.overrideWithValue(guest)],
      child: MaterialApp.router(routerConfig: navigation.router),
    ));
    await tester.pumpAndSettle();

    guest.setSigningOut(true);
    signedIn = false;
    authChanges.add(null);
    await guest.stopAfterSync();
    await guest.start();
    await tester.pump();
    expect(navigation.router.routeInformationProvider.value.uri.path, '/home');
    expect(find.byType(GettingStartedPage), findsNothing);

    await guest.enterAfterSignOut(currency: 'MGA', language: 'en');
    guest.setSigningOut(false);
    await tester.pumpAndSettle();
    expect(navigation.router.routeInformationProvider.value.uri.path, '/home');
    expect(find.byType(HomeDashboard), findsOneWidget);
  });

  testWidgets('app relaunch after guest login and logout skips onboarding',
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
    await guest.onboarding.complete(
      currency: 'MGA',
      language: 'en',
      categories: const [],
      wallets: const [],
    );
    guest.markOnboardingComplete();
    await guest.markChoiceSeen();
    await guest.stopAfterSync();
    await guest.enterAfterSignOut(currency: 'MGA', language: 'en');

    final relaunchedGuest = await GuestSession.load(database);
    final authChanges = StreamController<Object?>.broadcast();
    final navigation = AppNavigation(
      isSignedIn: () => false,
      authChanges: authChanges.stream,
      guestSession: relaunchedGuest,
    );
    addTearDown(() async {
      navigation.dispose();
      await authChanges.close();
    });
    await tester.pumpWidget(ProviderScope(
      overrides: [guestSessionProvider.overrideWithValue(relaunchedGuest)],
      child: MaterialApp.router(routerConfig: navigation.router),
    ));
    await tester.pumpAndSettle();

    expect(navigation.router.routeInformationProvider.value.uri.path, '/home');
    expect(find.byType(GettingStartedPage), findsNothing);
    expect(find.byType(HomeDashboard), findsOneWidget);
    expect(
        tester
            .widget<HomeBottomNavigationBar>(
              find.byType(HomeBottomNavigationBar),
            )
            .selectedIndex,
        0);
  });
}
