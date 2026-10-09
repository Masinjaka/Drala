import 'dart:async';

import 'package:budgets/features/ai_entry/domain/models/finance_entry_page.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/paged_ai_entry_repository_fake.dart';

void main() {
  test('loads day entries in pages and stops at the final page', () async {
    final repository = PagedAiEntryRepositoryFake();
    final model = AiEntryViewModel(repository, DateTime(2026, 7, 17));

    await model.loadDate(DateTime(2026, 7, 17));
    expect(model.entries.length, 20);
    expect(model.hasMoreEntries, isTrue);
    expect(repository.pageCalls, 1);
    expect(repository.dateLoadCount, 0);

    await model.loadMoreEntries();
    expect(model.entries.length, 40);
    expect(model.hasMoreEntries, isTrue);

    await model.loadMoreEntries();
    expect(model.entries.length, 45);
    expect(model.hasMoreEntries, isFalse);
    await model.loadMoreEntries();
    expect(repository.pageCalls, 3);
  });

  test('shows loading state and prevents duplicate page requests', () async {
    final repository = PagedAiEntryRepositoryFake();
    final model = AiEntryViewModel(repository, DateTime(2026, 7, 17));
    await model.loadDate(DateTime(2026, 7, 17));
    repository.pendingPage = Completer<FinanceEntryPage>();

    final load = model.loadMoreEntries();
    final duplicate = model.loadMoreEntries();
    expect(model.isLoadingMoreEntries, isTrue);
    expect(repository.pageCalls, 2);

    repository.pendingPage!.complete(repository.pageAt(20, 20));
    await Future.wait([load, duplicate]);
    expect(model.isLoadingMoreEntries, isFalse);
    expect(model.entries.length, 40);
  });

  test('ignores an old page after the selected date changes', () async {
    final repository = PagedAiEntryRepositoryFake();
    final model = AiEntryViewModel(repository, DateTime(2026, 7, 17));
    await model.loadDate(DateTime(2026, 7, 17));
    final oldPage = Completer<FinanceEntryPage>();
    repository.pendingPage = oldPage;
    final pendingLoad = model.loadMoreEntries();

    repository.pendingPage = null;
    await model.loadDate(DateTime(2026, 7, 18));
    oldPage.complete(repository.pageAt(20, 20));
    await pendingLoad;

    expect(model.entries.length, 20);
    expect(model.isLoadingMoreEntries, isFalse);
  });
}
