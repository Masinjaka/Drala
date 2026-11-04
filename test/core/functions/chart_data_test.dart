import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/functions/chart_data.dart';
import 'package:budgets/core/ui/app_danger_theme.dart';
import 'package:budgets/features/transactions/domain/model/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('period charts preserve income/expense totals and series colors', () {
    final now = DateTime.now();
    final transactions = [
      TransactionModel(
          date: now, amount: 12, transactionType: TransactionType.expense),
      TransactionModel(
          date: now, amount: 5, transactionType: TransactionType.expense),
      TransactionModel(
          date: now, amount: 30, transactionType: TransactionType.income),
    ];
    for (final data in [
      AppChartData.getDailyHourlyData(transactions),
      AppChartData.getWeeklyExpenseIncomeData(transactions),
      AppChartData.getWeeklyDailyData(transactions),
      AppChartData.getMonthlyWeeklyData(transactions),
      AppChartData.getYearlyMonthlyData(transactions),
    ]) {
      expect(
          data.fold<double>(0, (total, group) => total + group.barRods[0].toY),
          17);
      expect(
          data.fold<double>(0, (total, group) => total + group.barRods[1].toY),
          30);
      expect(
          data.every((group) =>
              group.barRods[0].color == AppDangerTheme.expenseSeries),
          isTrue);
    }
    final expenses = transactions.take(2).toList();
    expect(AppChartData.getWeeklyData(expenses).last.barRods.single.toY, 17);
    expect(AppChartData.getMonthlyData(expenses)[now.month - 1].y, 17);
    expect(AppChartData.getYearlyData(expenses).last.y, 17);
  });
}
