import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/delayed_edit_repository.dart';

void main() {
  for (final fields in [
    {'title'},
    {'category', 'amount'},
    {'title', 'category', 'amount'},
    {'type'},
    {'description'},
    <String>{},
  ]) {
    test('tracks only changed visible fields for $fields until save completes',
        () async {
      final repository = DelayedEditRepository()..entries = [_entry];
      final model = AiEntryViewModel(repository, _entry.occurredAt);
      addTearDown(model.dispose);
      await model.loadDate(_entry.occurredAt);
      final input = ManualEntryInput(
        title: fields.contains('title') ? 'Dinner' : _entry.title,
        categoryId: fields.contains('category') ? 'other' : _entry.categoryId,
        amount: fields.contains('amount') ? 20000 : 10000,
        transactionType: fields.contains('type') ? 'income' : 'expense',
        description: fields.contains('description') ? 'New note' : '',
        occurredAt: _entry.occurredAt,
      );
      final save = model.updateFinanceEntry(_entry.id, input);
      final changes = model.pendingEdits[_entry.id]!;
      expect(changes.title, fields.contains('title'));
      expect(changes.category, fields.contains('category'));
      expect(
          changes.amount, fields.contains('amount') || fields.contains('type'));
      expect(model.pendingEdits.keys, [_entry.id]);
      expect(model.isAddingEntry, isFalse);
      expect(model.entries.single, same(_entry));

      repository.edit.complete();
      await save;
      expect(model.pendingEdits, isEmpty);
      expect(model.entries.single.title, input.title);
      expect(model.entries.single.amount, input.amount);
    });
  }

  test('clears pending fields and preserves original values on failure',
      () async {
    final repository = DelayedEditRepository()..entries = [_entry];
    final model = AiEntryViewModel(repository, _entry.occurredAt);
    addTearDown(model.dispose);
    await model.loadDate(_entry.occurredAt);
    final save = model.updateFinanceEntry(
        _entry.id,
        ManualEntryInput(
          title: 'Dinner',
          amount: 20000,
          categoryId: 'other',
          transactionType: 'expense',
          occurredAt: _entry.occurredAt,
        ));
    final assertion = expectLater(save, throwsStateError);
    repository.edit.completeError(StateError('Save failed'));
    await assertion;
    expect(model.pendingEdits, isEmpty);
    expect(model.entries.single, same(_entry));
    expect(model.isSubmitting, isFalse);
  });
}

final _entry = FinanceEntry(
  id: 'entry',
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
