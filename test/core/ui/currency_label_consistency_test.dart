import 'package:budgets/core/theme.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_amount.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_card.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_overview_card.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_metric_card.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets('currency sizes match the edit sheet in ${theme.brightness}',
        (tester) async {
      final controller = TextEditingController(text: '1000');
      addTearDown(controller.dispose);
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Scaffold(
          body: Column(children: [
            TransactionAmountField(controller: controller, currencyCode: 'MGA'),
            const EnvelopeAmount(value: 1000, currencyCode: 'MGA'),
            WalletOverviewCard(
              wallet: const WalletSummary(
                id: 'cash',
                name: 'Cash',
                balance: 1000,
                currencyCode: 'MGA',
                iconKey: 'cash',
                isDefault: true,
              ),
              index: 0,
              onPressed: () {},
            ),
            const StatsMetricCard(
                label: 'Income', value: 1000, emoji: '', currencyCode: 'MGA'),
            const HomeBalanceCard(
                balance: 1000, income: 0, expenses: 0, currencyCode: 'MGA'),
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      final reference = tester.widget<Text>(find.descendant(
          of: find.byType(TransactionAmountField), matching: find.text('MGA')));
      for (final type in [EnvelopeAmount, WalletOverviewCard]) {
        final amount = tester.widget<Text>(find.descendant(
            of: find.byType(type), matching: find.text('1 k MGA')));
        final suffix = (amount.textSpan as TextSpan).children!.last as TextSpan;
        expect(suffix.style!.fontSize, reference.style!.fontSize);
      }
      for (final type in [StatsMetricCard, HomeBalanceCard]) {
        final currency = tester.widget<Text>(
            find.descendant(of: find.byType(type), matching: find.text('MGA')));
        expect(currency.style!.fontSize, reference.style!.fontSize);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
