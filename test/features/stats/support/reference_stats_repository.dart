import 'dart:math' as math;
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';

class ReferenceStatsRepository implements MonthlyStatsRepository {
  const ReferenceStatsRepository();
  @override
  Future<MonthlyStats> statsForMonth(DateTime month) async {
    final days = DateTime(month.year, month.month + 1, 0).day;
    final raw = List.generate(
        days,
        (i) => i == 0
            ? 0.0
            : 1 -
                math.exp(-i / 2) +
                math.pow(i / days, 4) * 1.1 -
                math.sin(i / days * math.pi) * .3);
    final sum = raw.fold<double>(0, (a, b) => a + b);
    final daily = raw.map((v) => (v / sum * 150000).round()).toList();
    daily[daily.length - 1] += 150000 - daily.fold<int>(0, (a, b) => a + b);
    return MonthlyStats(
        income: 2500000,
        expenses: 150000,
        transactionCount: 33,
        largestExpense: 45000,
        previousExpenses: 147493,
        expenseCategories: const [
          CategoryStat(
              name: 'Food & drinks',
              emoji: '',
              iconKey: 'food',
              colorHex: 'FFFB9F89',
              amount: 105000,
              transactionCount: 13),
          CategoryStat(
              name: 'Groceries',
              emoji: '',
              iconKey: 'groceries',
              colorHex: 'FFC4AF9A',
              amount: 30000,
              transactionCount: 8),
          CategoryStat(
              name: 'Transport',
              emoji: '',
              iconKey: 'transport',
              colorHex: 'FF8E8DBE',
              amount: 10500,
              transactionCount: 8),
          CategoryStat(
              name: 'Shopping',
              emoji: '',
              iconKey: 'shopping',
              colorHex: 'FF10B981',
              amount: 4500,
              transactionCount: 3),
        ],
        dailyExpenses: daily,
        currencyCode: 'MGA');
  }
}
