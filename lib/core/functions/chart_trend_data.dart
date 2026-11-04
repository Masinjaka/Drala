part of 'chart_data.dart';

List<FlSpot> _getMonthlyData(List<TransactionModel> expenses) {
  final now = DateTime.now();
  final currentYear = now.year;

  // Map to store monthly totals: month number (1-12) -> total amount.
  Map<int, double> monthlyTotals = {
    for (int i = 1; i <= 12; i++) i: 0.0 // Initialize all 12 months to 0
  };

  // Aggregate expenses into monthly totals, only for the current year.
  for (var expense in expenses) {
    if (expense.date!.year == currentYear) {
      monthlyTotals[expense.date!.month] =
          (monthlyTotals[expense.date!.month] ?? 0.0) + expense.amount!;
    }
  }

  // Convert aggregated monthly data into FlSpot objects for the line chart.
  // Ensure all 12 months are represented, even if their total is 0.
  List<FlSpot> spots = [];
  for (int i = 1; i <= 12; i++) {
    // Iterate from January (1) to December (12)
    spots.add(FlSpot((i - 1).toDouble(), monthlyTotals[i] ?? 0.0));
  }
  return spots;
}

List<FlSpot> _getYearlyData(List<TransactionModel> expenses) {
  final now = DateTime.now();
  // Get the current year.
  final currentYear = now.year;

  // Map to store yearly totals: year -> total amount.
  Map<int, double> yearlyTotals = {};

  // Initialize totals for the last 3 years (current year and two previous).
  for (int i = 0; i < 3; i++) {
    yearlyTotals[currentYear - i] = 0.0;
  }

  // Aggregate expenses by year, considering only the last 3 years.
  for (var expense in expenses) {
    final year = expense.date!.year;
    if (year >= currentYear - 2 && year <= currentYear) {
      // Filter for last 3 years
      yearlyTotals[year] = (yearlyTotals[year] ?? 0.0) + expense.amount!;
    }
  }

  // Sort the years to ensure chronological order for the chart.
  final sortedYears = yearlyTotals.keys.toList()..sort();

  // Convert aggregated yearly data into FlSpot objects for the line chart.
  List<FlSpot> spots = [];
  for (int i = 0; i < sortedYears.length; i++) {
    spots.add(FlSpot(i.toDouble(), yearlyTotals[sortedYears[i]] ?? 0.0));
  }
  return spots;
}

Map<String, dynamic> _getCategoryPieData(
    List<TransactionModel> transactions, TransactionType type) {
  Map<String, double> categoryTotals = {};
  Map<String, String> categoryColors = {};
  Map<String, String> categoryEmojis = {};

  // Aggregate transactions by category
  for (var transaction in transactions) {
    if (transaction.transactionType == type && transaction.category != null) {
      final categoryName = transaction.category!.name ?? 'Unknown';
      categoryTotals[categoryName] =
          (categoryTotals[categoryName] ?? 0.0) + (transaction.amount ?? 0.0);
      categoryColors[categoryName] = transaction.category!.color ?? 'FF10B981';
      categoryEmojis[categoryName] = transaction.category!.emoji ?? '❓';
    }
  }

  return {
    'totals': categoryTotals,
    'colors': categoryColors,
    'emojis': categoryEmojis,
  };
}
