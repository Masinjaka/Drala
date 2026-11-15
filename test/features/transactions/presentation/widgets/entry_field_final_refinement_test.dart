import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/reference_wallet_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_field.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'entry field icons and action focus border in ${theme.brightness}',
        (tester) async {
      final title = TextEditingController();
      addTearDown(title.dispose);
      var opened = false;
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: FinanceSheetScope(
                child: Column(children: [
          ReferenceWalletField(
              label: 'Wallet',
              wallets: const [
                WalletSummary(
                    id: 'bank',
                    name: 'Reserve',
                    balance: 100,
                    currencyCode: 'MGA',
                    iconKey: 'bank',
                    isDefault: true),
              ],
              value: 'bank',
              onChanged: (_) {},
              requiredSelection: true),
          ReferenceWalletField(
              label: 'Destination',
              wallets: const [],
              value: null,
              onChanged: (_) {},
              requiredSelection: true),
          TransactionCategoryField(
              label: 'Category',
              category: Category(
                  id: 'food', name: 'Food', iconKey: 'food', color: '#FF8800'),
              onTap: () => opened = true,
              onClear: () => fail('No clear action')),
          TransactionSheetField(label: 'Title', controller: title),
        ]))),
      ));
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
      expect(find.byIcon(Icons.account_balance), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byType(CategoryIcon), findsOneWidget);
      await tester.tap(find.byKey(const Key('transaction-category-field')));
      expect(opened, true);
      final input = find.byType(TextFormField);
      await tester.tap(input);
      await tester.pumpAndSettle();
      final decoration =
          tester.widget<TextField>(find.byType(TextField)).decoration!;
      expect((decoration.focusedBorder! as OutlineInputBorder).borderSide.color,
          AppFinanceSurfaceTheme.action(tester.element(input)));
      final normal = decoration.enabledBorder! as OutlineInputBorder;
      expect((decoration.errorBorder! as OutlineInputBorder).borderSide.width,
          normal.borderSide.width);
      expect(
          (decoration.focusedErrorBorder! as OutlineInputBorder)
              .borderSide
              .width,
          normal.borderSide.width);
      expect(tester.takeException(), isNull);
    });
  }
}
