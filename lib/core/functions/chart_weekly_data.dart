part of 'chart_data.dart';

List<BarChartGroupData> _getWeeklyExpenseIncomeData(
    List<TransactionModel> transactions) {
  final now = DateTime.now();
  // Create a list of the last 7 days, normalized to the start of each day.
  List<DateTime> last7Days = List.generate(7, (index) {
    final date = now.subtract(Duration(days: 6 - index));
    return DateTime(date.year, date.month, date.day);
  });

  // Maps to store daily totals for expenses and income
  Map<int, double> dailyExpenses = {for (int i = 0; i < 7; i++) i: 0.0};
  Map<int, double> dailyIncome = {for (int i = 0; i < 7; i++) i: 0.0};

  // Aggregate transactions by type
  for (var transaction in transactions) {
    final transactionDay = DateTime(
        transaction.date!.year, transaction.date!.month, transaction.date!.day);

    final dayIndex = last7Days.indexOf(transactionDay);

    if (dayIndex != -1) {
      if (transaction.transactionType == TransactionType.expense) {
        dailyExpenses[dayIndex] =
            (dailyExpenses[dayIndex] ?? 0.0) + (transaction.amount ?? 0.0);
      } else if (transaction.transactionType == TransactionType.income) {
        dailyIncome[dayIndex] =
            (dailyIncome[dayIndex] ?? 0.0) + (transaction.amount ?? 0.0);
      }
    }
  }

  // Convert aggregated data into BarChartGroupData with two bars per day
  return List.generate(7, (index) {
    return BarChartGroupData(
      x: index,
      barRods: [
        // Red bar for expenses
        BarChartRodData(
          toY: dailyExpenses[index] ?? 0.0,
          color: AppDangerTheme.expenseSeries,
          width: 18,
          borderRadius: BorderRadius.circular(12),
        ),
        // Green bar for income
        BarChartRodData(
          toY: dailyIncome[index] ?? 0.0,
          color: Colors.greenAccent,
          width: 18,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  });
}

List<BarChartGroupData> _getWeeklyData(List<TransactionModel> expenses) {
  final now = DateTime.now();
  // Create a list of the last 7 days, normalized to the start of each day.
  // This helps in consistent comparison regardless of time.
  List<DateTime> last7Days = List.generate(7, (index) {
    final date = now.subtract(Duration(days: 6 - index));
    return DateTime(
        date.year, date.month, date.day); // Normalize to start of day
  });

  // Map to store daily totals, using the day's index (0-6) as key.
  Map<int, double> dailyTotals = {for (int i = 0; i < 7; i++) i: 0.0};

  // Aggregate expenses.
  for (var expense in expenses) {
    // Normalize the expense date to the start of its day.
    final expenseDay =
        DateTime(expense.date!.year, expense.date!.month, expense.date!.day);

    // Find the index of the matching day in our last7Days list.
    // If expenseDay matches last7Days[0], index is 0.
    // If expenseDay matches last7Days[6] (today), index is 6.
    final dayIndex = last7Days.indexOf(expenseDay);

    if (dayIndex != -1) {
      // If the expense falls within the last 7 days
      dailyTotals[dayIndex] = (dailyTotals[dayIndex] ?? 0.0) + expense.amount!;
    }
  }

  // Convert aggregated daily data into BarChartGroupData.
  return List.generate(7, (index) {
    return BarChartGroupData(
      x: index, // X-axis value representing the day index (0-6).
      barRods: [
        BarChartRodData(
          toY: dailyTotals[index] ??
              0.0, // Y-axis value representing the expense amount.
          color: Colors.greenAccent,
          width: 24,
          borderRadius: BorderRadius.circular(20),
        ),
      ],
    );
  });
}
