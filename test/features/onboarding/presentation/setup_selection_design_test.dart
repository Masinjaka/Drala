import '../../../support/soft_shadow_test_binding.dart';
import '../../../support/load_category_icon_font.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/onboarding/domain/providers/onboarding_providers.dart';
import 'package:budgets/features/onboarding/presentation/pages/account_setup_page.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_choice.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_grid_choice.dart';
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
    await loadCategoryIconFont();
    await (FontLoader(AppTheme.fontFamily)
          ..addFont(rootBundle.load('assets/fonts/Alexandria-Regular.ttf')))
        .load();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });

  for (final dark in [false, true]) {
    for (final step in [3, 4, 5]) {
      testWidgets('selection design step $step ${dark ? "dark" : "light"}',
          (tester) async {
        SharedPreferences.setMockInitialValues({'selected_locale': 'en'});
        tester.view.physicalSize = const Size(412, 917);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repo = FakeOnboardingRepository()
          ..draft = {'step': step, 'language': 'en'};
        await tester.pumpWidget(ProviderScope(
          overrides: [
            onboardingRepositoryProvider.overrideWithValue(repo),
            exchangeRatesProvider.overrideWithValue(const AsyncData(null)),
          ],
          child: MaterialApp(
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: const MediaQuery(
              data: MediaQueryData(
                size: Size(412, 917),
                padding: EdgeInsets.only(bottom: 35),
                disableAnimations: true,
              ),
              child: RepaintBoundary(
                key: Key('selection-screen'),
                child: AccountSetupPage(),
              ),
            ),
          ),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        for (var page = 2; page <= 6; page++) {
          expect(find.byKey(ValueKey('setup-progress-$page')), findsOneWidget);
        }
        expect(
          tester.getRect(find.widgetWithText(CustomButton, 'Continue')),
          const Rect.fromLTWH(29, 808, 354, 44),
        );
        if (step == 3) {
          expect(find.byType(CircularProgressIndicator), findsNothing);
          expect(find.byType(SetupChoice), findsAtLeastNWidgets(4));
          expect(tester.getRect(find.widgetWithText(SetupChoice, 'Euro')),
              const Rect.fromLTWH(29, 322, 354, 50));
        } else if (step == 4) {
          expect(
              tester.getRect(find.widgetWithText(SetupGridChoice, 'Groceries')),
              const Rect.fromLTWH(29, 304, 172, 50));
        }
        await expectLater(
          find.byKey(const Key('selection-screen')),
          matchesGoldenFile(
              'goldens/selection-$step-${dark ? "dark" : "light"}.png'),
        );
        if (step == 3) {
          await tester.enterText(find.byType(TextField), 'CAD');
          await tester.pumpAndSettle();
          final canadian = find.widgetWithText(SetupChoice, 'Canadian Dollar');
          expect(canadian, findsOneWidget);
          await tester.tap(find.text('Canadian Dollar'));
          await tester.pumpAndSettle();
          await tester.pump(const Duration(milliseconds: 100));
          await tester.pumpAndSettle();
          expect(tester.widget<SetupChoice>(canadian).selected, isTrue);
        } else {
          final label = step == 4 ? 'Groceries' : 'Cash';
          final choice = find.widgetWithText(SetupGridChoice, label);
          expect(tester.widget<SetupGridChoice>(choice).selected, isTrue);
          await tester.tap(find.text(label));
          await tester.pumpAndSettle();
          expect(tester.widget<SetupGridChoice>(choice).selected, isFalse);
        }
      });
    }
  }
}
