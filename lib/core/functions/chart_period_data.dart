part of 'chart_data.dart';

List<BarChartGroupData> _getDailyHourlyData(
    List<TransactionModel> transactions) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Maps to store hourly totals for expenses and income
  Map<int, double> hourlyExpenses = {for (int i = 0; i < 24; i++) i: 0.0};
  Map<int, double> hourlyIncome = {for (int i = 0; i < 24; i++) i: 0.0};

  // Aggregate transactions by hour for today only
  for (var transaction in transactions) {
    final transactionDay = DateTime(
        transaction.date!.year, transaction.date!.month, transaction.date!.day);

    if (transactionDay.isAtSameMomentAs(today)) {
      final hour = transaction.date!.hour;
      if (transaction.transactionType == TransactionType.expense) {
        hourlyExpenses[hour] =
            (hourlyExpenses[hour] ?? 0.0) + (transaction.amount ?? 0.0);
      } else if (transaction.transactionType == TransactionType.income) {
        hourlyIncome[hour] =
            (hourlyIncome[hour] ?? 0.0) + (transaction.amount ?? 0.0);
      }
    }
  }

  // Convert aggregated data into BarChartGroupData
  return List.generate(24, (index) {
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: hourlyExpenses[index] ?? 0.0,
          color: AppDangerTheme.expenseSeries,
          width: 18,
          borderRadius: BorderRadius.circular(12),
        ),
        BarChartRodData(
          toY: hourlyIncome[index] ?? 0.0,
          color: Colors.greenAccent,
          width: 18,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  });
}

List<BarChartGroupData> _getMonthlyWeeklyData(
    List<TransactionModel> transactions) {
  final now = DateTime.now();

  // Calculate the start of each week (4 weeks back from current week)
  List<DateTime> weekStarts = [];
  for (int i = 3; i >= 0; i--) {
    final weekStart = now.subtract(Duration(days: now.weekday - 1 + (i * 7)));
    weekStarts.add(DateTime(weekStart.year, weekStart.month, weekStart.day));
  }

  // Maps to store weekly totals
  Map<int, double> weeklyExpenses = {for (int i = 0; i < 4; i++) i: 0.0};
  Map<int, double> weeklyIncome = {for (int i = 0; i < 4; i++) i: 0.0};

  // Aggregate transactions by week
  for (var transaction in transactions) {
    final transactionDay = DateTime(
        transaction.date!.year, transaction.date!.month, transaction.date!.day);

    for (int i = 0; i < 4; i++) {
      final weekStart = weekStarts[i];
      final weekEnd = weekStart.add(const Duration(days: 7));

      if (transactionDay.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          transactionDay.isBefore(weekEnd)) {
        if (transaction.transactionType == TransactionType.expense) {
          weeklyExpenses[i] =
              (weeklyExpenses[i] ?? 0.0) + (transaction.amount ?? 0.0);
        } else if (transaction.transactionType == TransactionType.income) {
          weeklyIncome[i] =
              (weeklyIncome[i] ?? 0.0) + (transaction.amount ?? 0.0);
        }
        break;
      }
    }
  }

  // Convert aggregated data into BarChartGroupData
  return List.generate(4, (index) {
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: weeklyExpenses[index] ?? 0.0,
          color: AppDangerTheme.expenseSeries,
          width: 18,
          borderRadius: BorderRadius.circular(12),
        ),
        BarChartRodData(
          toY: weeklyIncome[index] ?? 0.0,
          color: Colors.greenAccent,
          width: 18,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  });
}

List<BarChartGroupData> _getYearlyMonthlyData(
    List<TransactionModel> transactions) {
  final now = DateTime.now();

  // Create list of last 12 months
  List<DateTime> last12Months = [];
  for (int i = 11; i >= 0; i--) {
    final month = DateTime(now.year, now.month - i, 1);
    last12Months.add(month);
  }

  // Maps to store monthly totals
  Map<int, double> monthlyExpenses = {for (int i = 0; i < 12; i++) i: 0.0};
  Map<int, double> monthlyIncome = {for (int i = 0; i < 12; i++) i: 0.0};

  // Aggregate transactions by month
  for (var transaction in transactions) {
    final transactionMonth =
        DateTime(transaction.date!.year, transaction.date!.month, 1);

    final monthIndex = last12Months.indexOf(transactionMonth);

    if (monthIndex != -1) {
      if (transaction.transactionType == TransactionType.expense) {
        monthlyExpenses[monthIndex] =
            (monthlyExpenses[monthIndex] ?? 0.0) + (transaction.amount ?? 0.0);
      } else if (transaction.transactionType == TransactionType.income) {
        monthlyIncome[monthIndex] =
            (monthlyIncome[monthIndex] ?? 0.0) + (transaction.amount ?? 0.0);
      }
    }
  }

  // Convert aggregated data into BarChartGroupData
  return List.generate(12, (index) {
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: monthlyExpenses[index] ?? 0.0,
          color: AppDangerTheme.expenseSeries,
          width: 18,
          borderRadius: BorderRadius.circular(12),
        ),
        BarChartRodData(
          toY: monthlyIncome[index] ?? 0.0,
          color: Colors.greenAccent,
          width: 18,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  });
}
