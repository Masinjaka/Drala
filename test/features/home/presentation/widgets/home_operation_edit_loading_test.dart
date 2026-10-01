import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/widgets/home_operations_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

import '../../../ai_entry/support/delayed_edit_repository.dart';

void main() {
  for (final titleOnly in [true, false]) {
    testWidgets(
        'shows only ${titleOnly ? 'title' : 'category and amount'} loading',
        (tester) async {
      final repository = DelayedEditRepository()
        ..entries = [_entry('edited'), _entry('other')];
      final model = AiEntryViewModel(repository, DateTime(2026, 7, 20));
      addTearDown(model.dispose);
      await model.loadDate(model.selectedDate);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListenableBuilder(
            listenable: model,
            builder: (context, _) => HomeOperationsList(
              entries: model.entries,
              isLoading: model.isLoading,
              isAdding: model.isAddingEntry,
              pendingEdits: model.pendingEdits,
              onEntryTap: (_) {},
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      final originalBounds =
          tester.getRect(find.byKey(const Key('operation-edited')));
      final save = model.updateFinanceEntry(
          'edited',
          ManualEntryInput(
            title: titleOnly ? 'Dinner' : 'Lunch',
            amount: titleOnly ? 10000 : 20000,
            categoryId: titleOnly ? 'food' : 'other',
            transactionType: 'expense',
            occurredAt: model.selectedDate,
          ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      for (final field in ['title', 'category', 'category-icon', 'amount']) {
        final loading = titleOnly ? field == 'title' : field != 'title';
        expect(
          find.descendant(
            of: find.byKey(Key('operation-$field-edited')),
            matching: find.byType(Shimmer),
          ),
          loading ? findsOneWidget : findsNothing,
        );
        expect(
          find.descendant(
            of: find.byKey(Key('operation-$field-other')),
            matching: find.byType(Shimmer),
          ),
          findsNothing,
        );
      }
      expect(tester.getRect(find.byKey(const Key('operation-edited'))),
          originalBounds);
      expect(find.byKey(const Key('pending-operation-skeleton')), findsNothing);
      expect(tester.takeException(), isNull);

      repository.edit.complete();
      await save;
      await tester.pumpAndSettle();
      expect(find.byType(Shimmer), findsNothing);
      expect(find.text(titleOnly ? 'Dinner' : 'Other'), findsOneWidget);
    });
  }
}

FinanceEntry _entry(String id) => FinanceEntry(
      id: id,
      title: 'Lunch',
      categoryName: 'Food',
      categoryId: 'food',
      amount: 10000,
      occurredAt: DateTime(2026, 7, 20),
      transactionType: 'expense',
      currencyCode: 'MGA',
      iconKey: 'food',
      emoji: '🍔',
    );
