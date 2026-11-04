import '../../../../support/soft_shadow_test_binding.dart';
import '../../../../support/load_category_icon_font.dart';
import '../../../../support/load_app_fonts.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/features/stats/presentation/pages/finance_stats_page.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_metric_card.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_category_donut.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_category_row.dart';
import 'package:budgets/features/stats/presentation/widgets/monthly_spending_chart.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/reference_stats_repository.dart';

void main() {
  SoftShadowTestBinding();
  setUpAll(() async {
    await loadCategoryIconFont();
    await loadAppFonts();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });
  for (final dark in [false, true]) {
    for (final categories in [false, true]) {
      testWidgets('reference stats categories=$categories dark=$dark',
          (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(412, 917);
        tester.view.padding = const FakeViewPadding(top: 24);
        tester.view.viewPadding = const FakeViewPadding(top: 24);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
              builder: (context) => Scaffold(
                  backgroundColor: AppStatsTheme.background(context),
                  body: FinanceStatsPage(
                      showBackButton: false,
                      repository: const ReferenceStatsRepository(),
                      initialMonth: DateTime(2026, 9)),
                  bottomNavigationBar: HomeBottomNavigationBar(
                      selectedIndex: 3, onSelected: (_) {}))),
        ));
        await tester.pumpAndSettle();
        if (categories) {
          await tester.tap(find.byKey(const Key('stats-categories-tab')));
          await tester.pumpAndSettle();
        }
        expect(tester.getRect(find.byKey(const Key('stats-pick-month'))),
            const Rect.fromLTWH(308, 33, 90, 46));
        expect(tester.getRect(find.byKey(const Key('month-carousel'))),
            const Rect.fromLTWH(69, 113, 281, 50));
        if (categories) {
          expect(tester.getRect(find.byType(StatsCategoryDonut)),
              const Rect.fromLTWH(16, 355, 382, 181));
          expect(tester.getRect(find.byType(StatsCategoryRow).first),
              const Rect.fromLTWH(16, 540, 382, 60));
        }
        if (!categories) {
          expect(tester.getRect(find.byType(StatsMetricCard).first),
              const Rect.fromLTWH(16, 354, 184, 170));
          expect(tester.getRect(find.byType(MonthlySpendingChart)),
              const Rect.fromLTWH(16, 540, 382, 265));
        }
        await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile(
                'goldens/stats-${categories ? 'categories' : 'numbers'}-${dark ? 'dark' : 'light'}.png'));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
