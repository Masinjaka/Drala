import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/presentation/widgets/add_envelope_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('stores a selected-currency envelope amount as MGA',
      (tester) async {
    int? savedAmount;
    bool? repeats;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => AddEnvelopeSheet.show(
                context,
                categories: const [_food],
                month: DateTime(2026, 7),
                currencyState: _usd,
                onSave: (_, __, amount, monthly) async {
                  savedAmount = amount;
                  repeats = monthly;
                },
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('USD'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), 'Food budget');
    await tester.enterText(find.byType(TextFormField).at(0), '200');
    await tester
        .ensureVisible(find.byKey(const Key('transaction-category-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('transaction-category-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('category-food')));
    await tester.tap(find.byKey(const Key('category-done')));
    await tester.pumpAndSettle();
    await tester
        .ensureVisible(find.byKey(const Key('envelope-repeat-monthly')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('envelope-repeat-monthly')));
    await tester.ensureVisible(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();

    expect(savedAmount, 1000000);
    expect(repeats, isTrue);
  });
}

const _food = EnvelopeCategory(
  id: 'food',
  name: 'Food',
  emoji: '🍔',
  color: 'FF888888',
);

const _usd = CurrencyState(
  code: 'USD',
  baseCode: 'MGA',
  rates: {'USD': 0.0002},
);
