import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_grid_painter.dart';
import 'package:budgets/features/stats/presentation/pages/finance_stats_page.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_amount.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/deferred_stats_repository.dart';

void main() {
  testWidgets(
      'stats gravity follows the selected month net and amount position',
      (tester) async {
    final repository = DeferredStatsRepository();
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FinanceStatsPage(
            initialMonth: DateTime(2026, 9), repository: repository)));
    await tester.pump();
    repository.completeAll();
    await tester.pumpAndSettle();
    AppGridPainter grid() => tester
        .widget<CustomPaint>(find.byKey(const Key('app-page-grid')))
        .painter! as AppGridPainter;
    expect(grid().mass.value, closeTo(AppGridPainter.strengthFor(8100), .0001));
    final anchor = find.byWidgetPredicate(
        (widget) => widget is StatsAmount && widget.key is GlobalKey);
    expect(anchor, findsOneWidget);
    expect(grid().center.value, tester.getCenter(anchor));
    await tester.fling(
        find.byKey(const Key('stats-month-pages')), const Offset(600, 0), 1200);
    await tester.pumpAndSettle();
    repository.completeAll();
    await tester.pumpAndSettle();
    expect(grid().mass.value, closeTo(AppGridPainter.strengthFor(7200), .0001));
    expect(anchor, findsOneWidget);
    expect(grid().center.value, tester.getCenter(anchor));
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });
}
