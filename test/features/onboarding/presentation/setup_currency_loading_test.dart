import 'dart:async';

import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/currency/exchange_rates.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_currency_choices.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_currency_skeleton.dart';
import 'package:budgets/features/settings/presentation/widgets/currency_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  testWidgets('currency choices shimmer until rates finish loading',
      (tester) async {
    final rates = Completer<ExchangeRates?>();
    await tester.pumpWidget(ProviderScope(
      overrides: [exchangeRatesProvider.overrideWith((ref) => rates.future)],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SetupCurrencyChoices(
                selected: 'MGA',
                onChanged: _ignoreSelection,
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();

    expect(find.byType(CurrencySearchField), findsOneWidget);
    expect(find.byType(SetupCurrencySkeleton), findsOneWidget);
    expect(find.byType(Shimmer), findsOneWidget);
    expect(find.text('Euro'), findsNothing);

    await tester.enterText(find.byType(TextField), 'EUR');
    rates.complete(null);
    await tester.pumpAndSettle();

    expect(find.byType(SetupCurrencySkeleton), findsNothing);
    expect(find.text('Euro'), findsOneWidget);
    expect(find.text('Ariary'), findsNothing);
  });
}

void _ignoreSelection(String _) {}
