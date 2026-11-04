import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/features/stats/presentation/pages/finance_stats_page.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_donut_painter.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_category_row.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/reference_stats_repository.dart';

void main() {
  testWidgets('category tab persists through a cached month swipe',
      (tester) async {
    await tester.pumpWidget(_fixture());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('stats-categories-tab')));
    await tester.pumpAndSettle();
    expect(find.byType(StatsCategoryRow), findsNWidgets(4));
    await tester.fling(
        find.byKey(const Key('stats-month-pages')), const Offset(600, 0), 1200);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('stats-categories-content')), findsOneWidget);
    expect(find.byKey(const Key('stats-numbers-content')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('category chart animates and privacy preserves activity counts',
      (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      final privacy = AmountVisibilityController();
      addTearDown(privacy.dispose);
      await tester.pumpWidget(_fixture(privacy: privacy));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('stats-categories-tab')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final chart = tester
          .widget<CustomPaint>(find.byKey(const Key('stats-category-donut')));
      expect((chart.painter! as StatsDonutPainter).progress,
          inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      privacy.toggle();
      await tester.pumpAndSettle();
      expect(find.text('13 activities'), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp(r'Ar 2,350,000')), findsNothing);
      expect(find.bySemanticsLabel(RegExp(r'-Ar 105,000')), findsNothing);
      expect(find.text('70%'), findsNothing);
      expect(find.text('***'), findsWidgets);
      privacy.toggle();
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel(RegExp(r'Ar 2,350,000')), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp(r'-Ar 105,000')), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });
}

Widget _fixture({AmountVisibilityController? privacy}) => MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(builder: (_) {
      final page = FinanceStatsPage(
          showBackButton: false,
          initialMonth: DateTime(2026, 9),
          repository: const ReferenceStatsRepository());
      return privacy == null
          ? page
          : AmountVisibilityScope(controller: privacy, child: page);
    }));
