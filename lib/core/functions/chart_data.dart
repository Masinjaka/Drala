import 'package:budgets/features/transactions/domain/model/transaction_model.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:budgets/core/ui/app_danger_theme.dart';

part 'chart_weekly_data.dart';
part 'chart_trend_data.dart';
part 'chart_period_data.dart';

class AppChartData {
  static List<BarChartGroupData> getWeeklyExpenseIncomeData(
          List<TransactionModel> transactions) =>
      _getWeeklyExpenseIncomeData(transactions);
  static List<BarChartGroupData> getWeeklyData(
          List<TransactionModel> expenses) =>
      _getWeeklyData(expenses);
  static List<FlSpot> getMonthlyData(List<TransactionModel> expenses) =>
      _getMonthlyData(expenses);
  static List<FlSpot> getYearlyData(List<TransactionModel> expenses) =>
      _getYearlyData(expenses);
  static List<BarChartGroupData> getDailyHourlyData(
          List<TransactionModel> transactions) =>
      _getDailyHourlyData(transactions);
  static List<BarChartGroupData> getWeeklyDailyData(
          List<TransactionModel> transactions) =>
      getWeeklyExpenseIncomeData(transactions);
  static List<BarChartGroupData> getMonthlyWeeklyData(
          List<TransactionModel> transactions) =>
      _getMonthlyWeeklyData(transactions);
  static List<BarChartGroupData> getYearlyMonthlyData(
          List<TransactionModel> transactions) =>
      _getYearlyMonthlyData(transactions);
  static Map<String, dynamic> getCategoryPieData(
          List<TransactionModel> transactions, TransactionType type) =>
      _getCategoryPieData(transactions, type);
}
