import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/guest/data/guest_entry_queries.dart';
import 'package:flutter_test/flutter_test.dart';
import '../support/guest_finance_fixture.dart';

void main() {
  test(
      'recent transactions are bounded, ordered, isolated, and span old months',
      () async {
    final fixture = await GuestFinanceFixture.open();
    addTearDown(fixture.database.close);
    await fixture.database.customStatement(
        'UPDATE guest_categories SET color = ? WHERE id = ?',
        ['FF8E8DBE', 'food']);
    for (var i = 0; i < 4; i++) {
      await fixture.repositories.mutations.add(ManualEntryInput(
          title: 'Purchase $i',
          amount: 1,
          transactionType: 'expense',
          categoryId: 'food',
          occurredAt: DateTime(2024, i + 1, 10),
          sourceWalletId: fixture.wallets.first.id));
    }
    final recent = await fixture.repositories.finance.recentTransactions();
    expect(recent.every((entry) => entry.categoryColor == 'FF8E8DBE'), isTrue);
    final stats =
        await fixture.repositories.stats.statsForMonth(DateTime(2024, 4));
    expect(stats.expenseCategories.single.colorHex, 'FF8E8DBE');
    expect(
        recent.map((e) => e.title), ['Purchase 3', 'Purchase 2', 'Purchase 1']);
    expect(
        await GuestEntryQueries(fixture.database, 'other').recentTransactions(),
        isEmpty);
    expect(await fixture.repositories.finance.recentTransactions(limit: 1),
        hasLength(1));
  });
}
