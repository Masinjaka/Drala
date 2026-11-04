import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/onboarding/domain/providers/onboarding_providers.dart';
import 'package:budgets/features/onboarding/presentation/pages/account_setup_page.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_grid_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_onboarding_repository.dart';

void main() {
  for (final step in [3, 4, 5]) {
    testWidgets('step $step keeps its action reachable with large text',
        (tester) async {
      SharedPreferences.setMockInitialValues({'selected_locale': 'en'});
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = FakeOnboardingRepository()..draft = {'step': step};
      await tester.pumpWidget(ProviderScope(
        overrides: [
          onboardingRepositoryProvider.overrideWithValue(repo),
          exchangeRatesProvider.overrideWithValue(const AsyncData(null)),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(
              size: Size(375, 667),
              textScaler: TextScaler.linear(1.6),
            ),
            child: AccountSetupPage(),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.getRect(find.text('Continue')).bottom, lessThan(667));
      if (step != 3) {
        final label = step == 4 ? 'Groceries' : 'Cash';
        await tester.ensureVisible(find.text(label));
        await tester.pumpAndSettle();
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<SetupGridChoice>(
                  find.widgetWithText(SetupGridChoice, label))
              .selected,
          isFalse,
        );
      }
    });
  }
}
