import 'package:budgets/core/theme.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';
import 'package:budgets/features/stats/presentation/pages/finance_stats_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('matches the Figma stats frame', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 917);
    tester.view.padding = const FakeViewPadding(top: 24);
    tester.view.viewPadding = const FakeViewPadding(top: 24);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FinanceStatsPage(
          repository: _StatsRepository(),
          initialMonth: DateTime(2026, 9),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/stats_figma.png'),
    );
  });
}

class _StatsRepository implements MonthlyStatsRepository {
  @override
  Future<MonthlyStats> statsForMonth(DateTime month) async =>
      const MonthlyStats(
        income: 500000,
        expenses: 250000,
        transactionCount: 6,
        largestExpense: 100000,
        previousExpenses: 200000,
        expenseCategories: [],
        dailyExpenses: [30, 80, 25, 110, 65, 95, 50, 130, 75],
        currencyCode: 'MGA',
      );
}
