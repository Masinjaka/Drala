import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/month_carousel.dart';
import 'package:budgets/features/stats/presentation/pages/finance_stats_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../../support/reference_stats_repository.dart';

void main() {
  for (final categories in [false, true]) {
    testWidgets(
        'month carousel scrolls with stats content categories=$categories',
        (tester) async {
      await _pump(tester);
      if (categories) {
        await tester.tap(find.byKey(const Key('stats-categories-tab')));
        await tester.pumpAndSettle();
      }
      final carousel = find.byKey(const Key('month-carousel'));
      final year = find.byKey(const Key('stats-pick-month'));
      final monthLabel = find.byKey(const Key('calendar-button-month'));
      expect(monthLabel, findsNothing);
      final initialCarousel = tester.getTopLeft(carousel).dy;
      final initialYear = tester.getTopLeft(year).dy;
      await tester.drag(
          find.byKey(const Key('stats-content-scroll')), const Offset(0, -160));
      await tester.pumpAndSettle();
      expect(carousel, findsNothing);
      expect(tester.getTopLeft(year).dy, initialYear);
      expect(monthLabel, findsOneWidget);
      await tester.drag(
          find.byKey(const Key('stats-content-scroll')), const Offset(0, 400));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(carousel).dy, closeTo(initialCarousel, .1));
      expect(monthLabel, findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('scrollable month tabs retain animated paging', (tester) async {
    await _pump(tester);
    final now = DateTime.now();
    final monthPager = find.descendant(
        of: find.byType(MonthCarousel), matching: find.byType(PageView));
    final controller = tester.widget<PageView>(monthPager).controller!;
    final start = controller.page!;
    await tester.tap(find.text(DateFormat.MMMM('en').format(now)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(controller.page!, greaterThan(start));
    expect(controller.page!, lessThan(start + 1));
    await tester.pumpAndSettle();
    expect(controller.page, start + 1);
    final statsPager =
        tester.widget<PageView>(find.byKey(const Key('stats-month-pages')));
    expect(statsPager.controller!.page, 1201);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 717);
  addTearDown(tester.view.reset);
  final now = DateTime.now();
  await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: FinanceStatsPage(
          showBackButton: false,
          initialMonth: DateTime(now.year, now.month - 1),
          repository: const ReferenceStatsRepository())));
  await tester.pumpAndSettle();
}
