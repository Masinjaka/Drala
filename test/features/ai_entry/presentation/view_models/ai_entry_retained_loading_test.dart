import 'dart:async';

import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/fake_ai_entry_repository.dart';

void main() {
  test('retains resolved rows only for the same date and rejects late results',
      () async {
    final today = DateTime(2026, 10, 3);
    final tomorrow = DateTime(2026, 10, 4);
    final row = FinanceEntry(
        id: 'old',
        title: 'Original row',
        amount: 100,
        occurredAt: today,
        categoryName: 'Food',
        emoji: '',
        iconKey: 'food',
        transactionType: 'expense',
        currencyCode: 'MGA');
    final repository = FakeAiEntryRepository()..entries = [row];
    final model = AiEntryViewModel(repository, today);
    addTearDown(model.dispose);
    await model.loadDate(today);
    expect(model.entries, [row]);

    final oldRequest = Completer<List<FinanceEntry>>();
    final newRequest = Completer<List<FinanceEntry>>();
    repository.onEntriesForDate =
        (date) => date == today ? oldRequest.future : newRequest.future;
    final refresh = model.loadDate(today);
    expect(model.entriesResolved, isTrue);
    expect(model.entries, [row]);

    final switchDate = model.loadDate(tomorrow);
    expect(model.entriesResolved, isFalse);
    expect(model.entries, isEmpty);
    newRequest.complete([]);
    await switchDate;
    expect(model.entriesResolved, isTrue);
    oldRequest.complete([row]);
    await refresh;
    expect(model.selectedDate, tomorrow);
    expect(model.entries, isEmpty);

    repository.onEntriesForDate = (_) async => throw StateError('offline');
    await expectLater(model.loadDate(today), throwsStateError);
    expect(model.entriesResolved, isFalse);
    expect(model.entriesLoadFailed, isTrue);
    expect(model.isLoading, isFalse);
  });
}
