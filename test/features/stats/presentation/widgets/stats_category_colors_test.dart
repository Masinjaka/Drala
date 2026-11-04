import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_category_icon.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/presentation/widgets/category_spending_list.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_category_donut.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_category_row.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_donut_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _categories = [
  CategoryStat(
      name: 'Food',
      emoji: '',
      iconKey: 'food',
      amount: 70,
      colorHex: '#123456'),
  CategoryStat(
      name: 'Transport',
      emoji: '',
      iconKey: 'transport',
      amount: 30,
      colorHex: 'FF8E8DBE'),
];

void main() {
  for (final dark in [false, true]) {
    testWidgets(
        'icons/charts retain saved colors and percentage badges use page background dark=$dark',
        (tester) async {
      await tester.pumpWidget(_fixture(dark, _categories));
      await tester.pumpAndSettle();
      expect(_painter(tester).colors,
          [const Color(0xFF123456), const Color(0xFF8E8DBE)]);
      final homeIcon = tester.widget<Icon>(find.descendant(
          of: find.byKey(const Key('home-icon')), matching: find.byType(Icon)));
      for (var index = 0; index < 2; index++) {
        final row = find.byType(StatsCategoryRow).at(index);
        final icon = tester.widget<Icon>(
            find.descendant(of: row, matching: find.byType(Icon)));
        expect(
            icon.color,
            AppCategoryIconTheme.color(
                tester.element(row), _categories[index].colorHex));
        if (index == 0) expect(icon.color, homeIcon.color);
        final containers = tester.widgetList<Container>(
            find.descendant(of: row, matching: find.byType(Container)));
        expect(
            containers.where((container) =>
                container.decoration is BoxDecoration &&
                (container.decoration! as BoxDecoration).color ==
                    AppStatsTheme.background(tester.element(row))),
            hasLength(1));
      }
      for (final label in ['70%', '30%']) {
        expect(tester.widget<Text>(find.text(label)).style!.color,
            dark ? AppTheme.textDark : AppTheme.interactiveTextColor);
      }
      await tester.pumpWidget(_fixture(dark, _categories.reversed.toList()));
      await tester.pumpAndSettle();
      expect(_painter(tester).colors,
          [const Color(0xFF8E8DBE), const Color(0xFF123456)]);
      expect(tester.takeException(), isNull);
    });
  }
}

StatsDonutPainter _painter(WidgetTester tester) => tester
    .widget<CustomPaint>(find.byKey(const Key('stats-category-donut')))
    .painter! as StatsDonutPainter;

Widget _fixture(bool dark, List<CategoryStat> categories) => MaterialApp(
    theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
    home: Scaffold(
        body: Column(children: [
      const HomeOverviewCategoryIcon(
          key: Key('home-icon'), iconKey: 'food', colorHex: '#123456'),
      StatsCategoryDonut(
          loading: false,
          stats: MonthlyStats(
              income: 0,
              expenses: 100,
              transactionCount: 2,
              largestExpense: 70,
              previousExpenses: 100,
              expenseCategories: categories,
              dailyExpenses: const [100],
              currencyCode: 'MGA')),
      CategorySpendingList(
          categories: categories, total: 100, currencyCode: 'MGA'),
    ])));
