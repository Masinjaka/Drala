import '../../../support/soft_shadow_test_binding.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/features/onboarding/domain/providers/onboarding_providers.dart';
import 'package:budgets/features/onboarding/presentation/pages/account_setup_page.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_choice.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_onboarding_repository.dart';

void main() {
  SoftShadowTestBinding();
  setUpAll(() async {
    await (FontLoader(AppTheme.fontFamily)
          ..addFont(rootBundle.load('assets/fonts/Alexandria-Regular.ttf')))
        .load();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });

  for (final dark in [false, true]) {
    testWidgets('language design ${dark ? "dark" : "light"}', (tester) async {
      SharedPreferences.setMockInitialValues({'selected_locale': 'en'});
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = FakeOnboardingRepository()
        ..draft = {'step': 2, 'language': 'fr'};
      await tester.pumpWidget(ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(repo),
          exchangeRatesProvider.overrideWith((ref) async => null),
        ],
        child: MaterialApp(
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(
              size: Size(412, 917),
              padding: EdgeInsets.only(bottom: 35),
            ),
            child: RepaintBoundary(
              key: Key('language-screen'),
              child: AccountSetupPage(),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      for (var step = 2; step <= 6; step++) {
        expect(find.byKey(ValueKey('setup-progress-$step')), findsOneWidget);
      }
      expect(find.byType(SetupChoice), findsNWidgets(4));
      final french = find.widgetWithText(SetupChoice, 'Francais');
      expect(tester.widget<SetupChoice>(french).selected, isTrue);
      expect(tester.getRect(french), const Rect.fromLTWH(29, 245, 354, 50));
      expect(
        tester.getRect(find.widgetWithText(CustomButton, 'Continue')),
        const Rect.fromLTWH(29, 808, 354, 44),
      );
      await expectLater(
        find.byKey(const Key('language-screen')),
        matchesGoldenFile('goldens/language-${dark ? "dark" : "light"}.png'),
      );
      await tester.tap(find.text('Deutch'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<SetupChoice>(find.widgetWithText(SetupChoice, 'Deutch'))
            .selected,
        isTrue,
      );
      expect(
        (await SharedPreferences.getInstance()).getString('selected_locale'),
        'de',
      );
      await tester.tap(find.text('Continue'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(repo.draft['language'], 'de');
      expect(repo.draft['step'], 3);
      expect(find.text('Your currency'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<SetupChoice>(find.widgetWithText(SetupChoice, 'Deutch'))
              .selected,
          isTrue);
    });
  }
}
