import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/guest/data/guest_entry_queries.dart';
import 'package:budgets/features/guest/data/guest_monthly_stats_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Queries extends Mock implements GuestEntryQueries {}

void main() {
  test('guest category counts include only matching monthly expenses',
      () async {
    final queries = _Queries();
    final month = DateTime(2026, 9);
    when(() => queries.entriesForMonth(month)).thenAnswer((_) async => [
          _entry('food', 100),
          _entry('food', 200),
          _entry('travel', 50),
          _entry('salary', 1000, income: true),
        ]);
    when(() => queries.entriesForMonth(DateTime(2026, 8)))
        .thenAnswer((_) async => []);
    final stats =
        await GuestMonthlyStatsRepository(queries).statsForMonth(month);
    expect(stats.expenseCategories.first.name, 'food');
    expect(stats.expenseCategories.first.amount, 300);
    expect(stats.expenseCategories.first.transactionCount, 2);
    expect(stats.expenseCategories.first.colorHex, 'FFFB9F89');
    expect(stats.expenseCategories.last.colorHex, 'FF8E8DBE');
    expect(stats.expenseCategories.last.transactionCount, 1);
    expect(stats.transactionCount, 4);
  });
}

FinanceEntry _entry(String category, double amount, {bool income = false}) =>
    FinanceEntry(
        id: '$category-$amount',
        title: category,
        categoryName: category,
        categoryColor: category == 'food' ? 'FFFB9F89' : 'FF8E8DBE',
        amount: amount,
        occurredAt: DateTime(2026, 9, 1),
        transactionType: income ? 'income' : 'expense',
        currencyCode: 'MGA',
        iconKey: category,
        emoji: '');
