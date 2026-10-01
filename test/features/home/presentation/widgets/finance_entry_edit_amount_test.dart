import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/domain/models/manual_entry_sheet_result.dart';
import 'package:budgets/features/home/presentation/widgets/finance_entry_detail_sheet_route.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../ai_entry/support/delayed_edit_repository.dart';

void main() {
  for (final editedAmount in [null, '2.680', '3.00']) {
    testWidgets('title edit with amount $editedAmount tracks actual changes',
        (tester) async {
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      ManualEntrySheetResult? result;
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Builder(builder: (context) {
          return TextButton(
            onPressed: () async {
              result = await showFinanceEntryDetailSheet(
                context,
                entry: _entry,
                categories: Future.value(const []),
                currencyState: const CurrencyState(
                  code: 'USD',
                  baseCode: 'MGA',
                  rates: {'MGA': 1, 'USD': 0.000223},
                ),
              );
            },
            child: const Text('Open'),
          );
        })),
      ));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('2.68'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(1), 'Dinner');
      if (editedAmount != null) {
        await tester.enterText(find.byType(TextFormField).first, editedAmount);
      }
      await tester.tap(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();

      final changedAmount = editedAmount == '3.00';
      expect(result!.input!.amount, changedAmount ? 13453 : 12000);
      final repository = DelayedEditRepository()..entries = [_entry];
      final model = AiEntryViewModel(repository, _entry.occurredAt);
      addTearDown(model.dispose);
      await model.loadDate(_entry.occurredAt);
      final save = model.updateFinanceEntry(_entry.id, result!.input!);
      final pending = model.pendingEdits[_entry.id]!;
      expect(pending.title, isTrue);
      expect(pending.amount, changedAmount);
      expect(pending.category, isFalse);
      repository.edit.complete();
      await save;
    });
  }
}

final _entry = FinanceEntry(
  id: 'entry',
  title: 'Lunch',
  categoryName: 'Food',
  categoryId: 'food',
  amount: 12000,
  occurredAt: DateTime(2026, 7, 20),
  transactionType: 'expense',
  currencyCode: 'MGA',
  iconKey: 'food',
  emoji: '🍔',
);
