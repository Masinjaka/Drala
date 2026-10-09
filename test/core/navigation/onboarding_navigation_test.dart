import 'dart:async';
import 'package:budgets/core/navigation/app_navigation.dart';
import 'package:budgets/features/onboarding/domain/providers/onboarding_providers.dart';
import 'package:budgets/features/onboarding/presentation/pages/account_setup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/onboarding/support/fake_onboarding_repository.dart';

void main() {
  testWidgets('new sessions and restarts cannot bypass unfinished setup',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final changes = StreamController<Object?>.broadcast();
    var signedIn = false;
    final navigation = AppNavigation(
        isSignedIn: () => signedIn,
        needsOnboarding: () => true,
        authChanges: changes.stream);
    await tester.pumpWidget(ProviderScope(overrides: [
      onboardingRepositoryProvider
          .overrideWithValue(FakeOnboardingRepository()),
    ], child: MaterialApp.router(routerConfig: navigation.router)));
    await tester.pumpAndSettle();
    signedIn = true;
    changes.add(null);
    await tester.pumpAndSettle();
    expect(find.byType(AccountSetupPage), findsOneWidget);
    for (final path in ['/home', '/signup', '/upload-profile-photo']) {
      navigation.router.go(path);
      await tester.pumpAndSettle();
      expect(navigation.router.routeInformationProvider.value.uri.path,
          '/onboarding');
    }
    await tester.pumpWidget(const SizedBox.shrink());
    navigation.dispose();
    await changes.close();
  });
}
