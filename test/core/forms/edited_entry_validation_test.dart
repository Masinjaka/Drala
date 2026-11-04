import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_toast_overlay.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/home/domain/models/manual_entry_sheet_result.dart';
import 'package:budgets/features/home/presentation/widgets/finance_entry_detail_sheet_route.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_field.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final type in ['income', 'expense']) {
    testWidgets(
        'edited $type identifies a missing category below the selector and saves after correction',
        (tester) async {
      tester.view.physicalSize = const Size(375, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      ManualEntrySheetResult? result;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                      onPressed: () async {
                        result = await showFinanceEntryDetailSheet(context,
                            entry: FinanceEntry(
                                id: 'entry',
                                title: 'Internet',
                                amount: 100,
                                categoryName: 'Internet',
                                categoryId: 'internet',
                                emoji: '😀',
                                transactionType: type,
                                currencyCode: 'MGA',
                                iconKey: 'other',
                                occurredAt: DateTime(2026, 10, 23)),
                            categories: Future.value([
                              ManualEntryCategory(
                                  id: 'internet',
                                  name: 'Internet',
                                  emoji: '😀',
                                  transactionType: type)
                            ]));
                      },
                      child: const Text('Open'),
                    ))),
      ));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester
          .ensureVisible(find.byKey(const Key('clear-transaction-category')));
      await tester.tap(find.byKey(const Key('clear-transaction-category')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      expect(
          find.descendant(
              of: find.byType(TransactionCategoryField),
              matching: find.text('This field is required.')),
          findsOneWidget);
      expect(find.byType(AppToastOverlay), findsNothing);
      expect(result, isNull);
      await tester
          .ensureVisible(find.byKey(const Key('transaction-category-field')));
      await tester.tap(find.byKey(const Key('transaction-category-field')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('category-internet')));
      await tester.tap(find.byKey(const Key('category-done')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      expect(result?.input?.categoryId, 'internet');
      expect(result?.input?.amount, 100);
      expect(result?.action, ManualEntrySheetAction.save);
      expect(tester.takeException(), isNull);
    });
  }
}
