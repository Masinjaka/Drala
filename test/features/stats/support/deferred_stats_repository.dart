import 'dart:async';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';

class DeferredStatsRepository implements MonthlyStatsRepository {
  final requests = <DateTime, Completer<MonthlyStats>>{};
  final calls = <DateTime>[];
  @override
  Future<MonthlyStats> statsForMonth(DateTime month) {
    calls.add(month);
    return (requests[month] = Completer<MonthlyStats>()).future;
  }

  void completeAll() {
    for (final entry in requests.entries) {
      if (!entry.value.isCompleted) entry.value.complete(value(entry.key));
    }
  }

  MonthlyStats value(DateTime month) => MonthlyStats(
      income: month.month * 1000,
      expenses: month.month * 100,
      transactionCount: month.month,
      largestExpense: 100,
      previousExpenses: 100,
      expenseCategories: [],
      dailyExpenses: [10, 20, 30],
      currencyCode: 'MGA');
}
