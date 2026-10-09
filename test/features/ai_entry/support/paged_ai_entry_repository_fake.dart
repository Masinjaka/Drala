import 'dart:async';

import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry_page.dart';
import 'package:budgets/features/ai_entry/domain/repositories/paged_ai_entry_repository.dart';

import 'fake_ai_entry_repository.dart';

class PagedAiEntryRepositoryFake extends FakeAiEntryRepository
    implements PagedAiEntryRepository {
  PagedAiEntryRepositoryFake() {
    entries = List.generate(45, (index) => _entry(index));
  }

  int pageCalls = 0;
  Completer<FinanceEntryPage>? pendingPage;

  @override
  Future<FinanceEntryPage> entriesForDatePage(
    DateTime date, {
    required int limit,
    required int transactionOffset,
    required int transferOffset,
  }) async {
    pageCalls++;
    if (pendingPage case final pending?) return pending.future;
    return pageAt(transactionOffset, limit);
  }

  FinanceEntryPage pageAt(int offset, int limit) => FinanceEntryPage(
        entries: entries.skip(offset).take(limit).toList(),
        transactionOffset: (offset + limit).clamp(0, entries.length),
        transferOffset: 0,
        hasMore: offset + limit < entries.length,
      );

  FinanceEntry _entry(int index) => FinanceEntry(
        id: '$index',
        title: 'Entry $index',
        categoryName: 'Food',
        amount: 100,
        occurredAt: DateTime(2026, 7, 17),
        transactionType: 'expense',
        currencyCode: 'MGA',
        iconKey: 'food',
        emoji: '🍔',
      );
}
