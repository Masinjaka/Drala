import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/guest/data/guest_entry_queries.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';

class GuestMonthlyStatsRepository implements MonthlyStatsRepository {
  const GuestMonthlyStatsRepository(this.queries);

  final GuestEntryQueries queries;

  @override
  Future<MonthlyStats> statsForMonth(DateTime month) async {
    final entries = await queries.entriesForMonth(month);
    final previous = await queries.entriesForMonth(
      DateTime(month.year, month.month - 1),
    );
    final expenses = entries.where((entry) => entry.isExpense).toList();
    final daily = List<int>.filled(
      DateTime(month.year, month.month + 1, 0).day,
      0,
    );
    final byCategory = <String, (String, int)>{};
    for (final entry in expenses) {
      final day = entry.occurredAt.day - 1;
      daily[day] += entry.amount.round();
      final prior = byCategory[entry.categoryName];
      byCategory[entry.categoryName] = (
        entry.emoji,
        (prior?.$2 ?? 0) + entry.amount.round(),
      );
    }
    return MonthlyStats(
      income: _sum(entries.where((entry) => entry.isIncome)),
      expenses: _sum(expenses),
      transactionCount: entries.length,
      largestExpense: expenses.fold<int>(
        0,
        (largest, entry) =>
            entry.amount.round() > largest ? entry.amount.round() : largest,
      ),
      previousExpenses: _sum(previous.where((entry) => entry.isExpense)),
      expenseCategories: [
        for (final category in byCategory.entries)
          CategoryStat(
            name: category.key,
            emoji: category.value.$1,
            amount: category.value.$2,
          ),
      ]..sort((a, b) => b.amount.compareTo(a.amount)),
      dailyExpenses: daily,
      currencyCode: 'MGA',
    );
  }

  int _sum(Iterable<FinanceEntry> entries) =>
      entries.fold(0, (total, entry) => total + entry.amount.round());
}
