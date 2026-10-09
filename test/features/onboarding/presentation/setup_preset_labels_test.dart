import 'package:budgets/core/theme.dart';
import 'package:budgets/features/onboarding/domain/models/onboarding_preset.dart';
import 'package:budgets/features/onboarding/domain/providers/onboarding_providers.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_preset_choices.dart';
import 'package:budgets/features/settings/domain/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_onboarding_repository.dart';

void main() {
  testWidgets('preset names follow the selected onboarding language',
      (tester) async {
    final repo = FakeOnboardingRepository();
    String? selectedSlug;
    const examples = [
      ('en', 'Groceries', 'Food & drinks', 'Salary'),
      ('fr', 'Courses', 'Repas et boissons', 'Salaire'),
      ('mg', 'Fiantsenana', 'Sakafo sy zava-pisotro', 'Karama'),
      ('de', 'Lebensmittel', 'Essen & Trinken', 'Gehalt'),
      ('es', 'Compras', 'Comida y bebida', 'Salario'),
      ('it', 'Spesa', 'Cibo e bevande', 'Stipendio'),
    ];

    for (final (language, shopping, food, salary) in examples) {
      await tester.pumpWidget(ProviderScope(
        overrides: [onboardingRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SetupPresetChoices(
                language: language,
                selected: const {},
                onChanged: (slug) => selectedSlug = slug,
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text(shopping), findsOneWidget);
      expect(find.text(food), findsOneWidget);
      expect(find.text(salary), findsOneWidget);
      if (language == 'fr') {
        await tester.tap(find.text('Courses'));
        expect(selectedSlug, 'shopping');
      }
    }
    expect(examples.map((example) => example.$1),
        supportedAppLocales.map((locale) => locale.languageCode));
  });

  test('preset JSON parses names and falls back to its default name', () {
    const row = {
      'slug': 'food',
      'name': 'Foods & Drinks',
      'transaction_type': 'expense',
      'icon_key': 'food',
      'name_translations': {'fr': 'Repas et boissons'},
    };
    final preset = OnboardingPreset.fromJson(row);
    expect(preset.nameFor('fr'), 'Repas et boissons');
    expect(preset.nameFor('it'), 'Foods & Drinks');
  });
}
