import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/ai_entry/presentation/widgets/finance_entry_item.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_card_heading.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_row.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_envelope_card.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_transaction_tile.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_category_field.dart';
import 'package:budgets/features/transactions/domain/model/transaction_model.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_chip.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_detail_header.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_list_item_content.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_category_row.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const hex = 'FF8040C0';
  const currency =
      CurrencyState(code: 'MGA', baseCode: 'MGA', rates: {'MGA': 1});
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    for (final type in TransactionType.values) {
      testWidgets(
          'category color propagates across $type in ${theme.brightness}',
          (tester) async {
        final category = Category(
            id: 'chosen',
            name: 'Chosen',
            iconKey: 'food',
            color: hex,
            transactionType: type);
        final transaction = TransactionModel(
            category: category, amount: 20, transactionType: type);
        final entry = FinanceEntry(
            id: 'entry',
            title: 'Entry',
            categoryName: 'Chosen',
            amount: 20,
            occurredAt: DateTime(2026, 10, 26),
            transactionType: type.value,
            currencyCode: 'MGA',
            iconKey: 'food',
            emoji: '',
            categoryColor: hex);
        const envelope = Envelope(
            id: 'envelope',
            name: 'Envelope',
            categoryId: 'chosen',
            categoryName: 'Chosen',
            emoji: '',
            iconKey: 'food',
            color: hex,
            amount: 100,
            spent: 20,
            currencyCode: 'MGA');
        final surfaces = <Widget>[
          HomeOverviewTransactionTile(entry: entry, onPressed: () {}),
          HomeOperationRow(entry: entry, currencyState: currency, onTap: () {}),
          FinanceEntryItem(entry: entry, currencyState: currency),
          HomeOverviewEnvelopeCard(envelope: envelope, onPressed: () {}),
          const EnvelopeCardHeading(envelope: envelope),
          TransactionListItemContent(
              transaction: transaction,
              currency: currency,
              borderRadius: BorderRadius.circular(16),
              onTap: () {}),
          TransactionDetailHeader(
              transaction: transaction,
              categoryColor: const Color(0xFF8040C0),
              currencyCode: 'MGA',
              rate: 1),
          TransactionCategoryChip(
              category: category, selected: false, onTap: () {}),
          TransactionCategoryChip(
              category: category, selected: true, onTap: () {}),
          ManualEntryCategoryField(categories: [
            ManualEntryCategory(
                id: 'chosen',
                name: 'Chosen',
                emoji: '',
                iconKey: 'food',
                colorHex: hex,
                transactionType: type.value)
          ], value: 'chosen', onChanged: (_) {}),
          const StatsCategoryRow(
              category: CategoryStat(
                  name: 'Chosen',
                  emoji: '',
                  iconKey: 'food',
                  colorHex: hex,
                  amount: 20),
              value: 20,
              total: 100,
              currencyCode: 'MGA'),
        ];
        for (final surface in surfaces) {
          await tester.pumpWidget(MaterialApp(
              theme: theme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                  body: Center(
                      child: SizedBox(
                          width: 500,
                          height: 220,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: surface))))));
          await tester.pumpAndSettle();
          final finder = find.byType(CategoryIcon);
          expect(finder, findsOneWidget, reason: '${surface.runtimeType}');
          final icon = tester.widget<CategoryIcon>(finder);
          expect(icon.colorHex, hex, reason: '${surface.runtimeType}');
          final rendered = tester.widget<Icon>(
              find.descendant(of: finder, matching: find.byType(Icon)));
          final context = tester.element(finder);
          expect(
              rendered.color,
              AppCategoryIconTheme.color(context, hex,
                  background: icon.backgroundColor),
              reason: '${surface.runtimeType}');
          expect(tester.takeException(), isNull,
              reason: '${surface.runtimeType}');
        }
      });
    }
  }
}
