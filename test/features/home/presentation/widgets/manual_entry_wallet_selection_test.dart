import 'package:budgets/core/theme.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/home/domain/models/manual_entry_sheet_result.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/features/home/presentation/widgets/reference_wallet_field.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final chooseWallet in [false, true]) {
    testWidgets(
        'manual entry ${chooseWallet ? 'uses explicit wallet' : 'preserves automatic funding'}',
        (tester) async {
      ManualEntrySheetResult? result;
      await tester.pumpWidget(MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
              body: Builder(
                  builder: (context) => TextButton(
                      onPressed: () async {
                        result = await ManualEntrySheet.show(context,
                            targetDate: DateTime(2026, 11, 2),
                            categories: Future.value(const [
                              ManualEntryCategory(
                                  id: 'food',
                                  name: 'Food',
                                  emoji: '',
                                  iconKey: 'food',
                                  transactionType: 'expense')
                            ]),
                            wallets: const [
                              WalletSummary(
                                  id: 'cash',
                                  name: 'Cash',
                                  balance: 10000,
                                  currencyCode: 'MGA',
                                  iconKey: 'cash',
                                  isDefault: true),
                              WalletSummary(
                                  id: 'bank',
                                  name: 'Reserve',
                                  balance: 20000,
                                  currencyCode: 'MGA',
                                  iconKey: 'bank',
                                  isDefault: false)
                            ]);
                      },
                      child: const Text('Open'))))));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('transaction-amount')), '20');
      await tester.enterText(find.byType(TextFormField).at(1), 'Lunch');
      await tester.tap(find.byKey(const Key('transaction-category-field')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('category-food')));
      await tester.pumpAndSettle();
      if (chooseWallet) {
        final wallet = find.byType(ReferenceWalletField);
        await tester.ensureVisible(wallet);
        await tester.pumpAndSettle();
        await tester.tap(wallet);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('wallet-choice-bank')));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      expect(result?.input?.sourceWalletId, chooseWallet ? 'bank' : null);
      expect(result?.input?.useAllWallets, false);
      expect(result?.input?.amount, 20);
      expect(tester.takeException(), isNull);
    });
  }
}
