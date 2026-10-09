import 'package:budgets/features/stats/presentation/pages/finance_stats_page.dart';
import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/cupertino.dart' show CupertinoPicker;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/deferred_stats_repository.dart';

void main() {
  testWidgets(
      'keeps metric titles while loading, swipes cached months and picks a year',
      (tester) async {
    final repository = DeferredStatsRepository();
    await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FinanceStatsPage(
            repository: repository, initialMonth: DateTime(2025, 6))));
    await tester.pump();
    expect(find.text('Income'), findsOneWidget);
    expect(find.byKey(const Key('stats-value-skeleton')), findsNWidgets(4));
    expect(find.byKey(const Key('stats-chart-empty')), findsOneWidget);
    expect(find.byKey(const Key('stats-line-chart')), findsNothing);
    expect(find.byType(ValueSkeleton), findsNWidgets(4));
    final skeletonFades = tester.widgetList<FadeTransition>(find.ancestor(
      of: find.byKey(const Key('stats-value-skeleton')).first,
      matching: find.byType(FadeTransition),
    ));
    expect(skeletonFades.every((fade) => fade.opacity.value == 1), isTrue);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('2025'), findsOneWidget);
    repository.completeAll();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('stats-chart-empty')), findsNothing);
    expect(find.byKey(const Key('stats-line-chart')), findsOneWidget);
    await tester.fling(
        find.byKey(const Key('stats-month-pages')), const Offset(600, 0), 1200);
    await tester.pumpAndSettle();
    expect(find.byType(ValueSkeleton), findsNothing);
    expect(repository.calls.where((month) => month == DateTime(2025, 5)).length,
        1);
    await tester.tap(find.byKey(const Key('stats-pick-month')));
    await tester.pumpAndSettle();
    expect(find.byType(CupertinoPicker), findsNWidgets(2));
    await tester.drag(find.byType(CupertinoPicker).last, const Offset(0, 88));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('app-wheel-picker-done')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    repository.completeAll();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final page =
        tester.widget<PageView>(find.byKey(const Key('stats-month-pages')));
    expect(page.controller!.page, lessThan(1199));
  });
}
