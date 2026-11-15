import 'package:budgets/core/theme.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';
import 'package:budgets/features/stats/presentation/pages/finance_stats_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/reference_stats_repository.dart';

void main() {
  for (final dark in [false, true]) {
    for (final empty in [false, true]) {
      testWidgets(
          'stats tabs fit narrow large French text dark=$dark empty=$empty',
          (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 640);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(MaterialApp(
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.6)),
              child: child!),
          home: FinanceStatsPage(
              showBackButton: false,
              repository:
                  empty ? _EmptyStats() : const ReferenceStatsRepository()),
        ));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('stats-numbers-content')), findsOneWidget);
        expect(tester.takeException(), isNull);
        await Scrollable.ensureVisible(
            tester.element(find.byKey(const Key('stats-categories-tab'))),
            alignment: .5);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('stats-categories-tab')));
        await tester.pumpAndSettle();
        expect(
            find.byKey(const Key('stats-categories-content')), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.drag(find.byKey(const Key('stats-content-scroll')),
            const Offset(0, -350));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}

class _EmptyStats implements MonthlyStatsRepository {
  @override
  Future<MonthlyStats> statsForMonth(DateTime month) async =>
      const MonthlyStats(
          income: 0,
          expenses: 0,
          transactionCount: 0,
          largestExpense: 0,
          previousExpenses: 0,
          expenseCategories: [],
          dailyExpenses: [],
          currencyCode: 'MGA');
}
