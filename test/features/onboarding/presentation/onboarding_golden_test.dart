import 'package:budgets/features/onboarding/presentation/pages/getting_started_page.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/auth/presentation/pages/login_page.dart';
import 'package:budgets/features/auth/presentation/pages/sign_up_page.dart';
import 'package:budgets/features/onboarding/domain/providers/onboarding_providers.dart';
import 'package:budgets/features/onboarding/presentation/pages/account_setup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../support/load_app_fonts.dart';
import '../support/fake_onboarding_repository.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });
  for (final dark in [false, true]) {
    for (final step in [-1, 0, 1, 2, 3, 4, 5, 6]) {
      testWidgets('render ${dark ? "dark" : "light"} step $step',
          (tester) async {
        SharedPreferences.setMockInitialValues({'selected_locale': 'en'});
        tester.view.physicalSize = const Size(1236, 2751);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repo = FakeOnboardingRepository()..draft = {'step': step};
        await tester.pumpWidget(ProviderScope(
            overrides: [
              onboardingRepositoryProvider.overrideWithValue(repo),
              exchangeRatesProvider.overrideWith((ref) async => null),
            ],
            child: MaterialApp(
                theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
                home: MediaQuery(
                  data: const MediaQueryData(
                    size: Size(412, 917),
                    padding: EdgeInsets.only(bottom: 35),
                  ),
                  child: RepaintBoundary(
                      key: const Key('screen'),
                      child: step == -1
                          ? const GettingStartedPage()
                          : step == 0
                              ? const LoginPage()
                              : step == 1
                                  ? const SignUpPage()
                                  : const AccountSetupPage()),
                ))));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(find.byKey(const Key('screen')),
            matchesGoldenFile('goldens/${dark ? "dark" : "light"}-$step.png'));
      });
    }
  }
}
