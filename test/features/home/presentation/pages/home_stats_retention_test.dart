import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../stats/support/deferred_stats_repository.dart';
import '../../support/overview_fixture.dart';

void main() {
  testWidgets('Stats keeps the resolved month while revisiting and refreshing',
      (tester) async {
    final stats = DeferredStatsRepository();
    await tester.pumpWidget(overviewFixture(statsRepository: stats));
    await tester.pumpAndSettle();
    final statsTab = find.byKey(const ValueKey('home-navigation-3'));
    final homeTab = find.byKey(const ValueKey('home-navigation-0'));
    await tester.tap(statsTab);
    await tester.pump();
    expect(find.text('Stats'), findsWidgets);
    expect(find.byType(ValueSkeleton), findsNothing);
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.byType(ValueSkeleton), findsWidgets);
    stats.completeAll();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('stats-line-chart')), findsOneWidget);

    await tester.tap(homeTab);
    await tester.pumpAndSettle();
    final calls = stats.calls.length;
    await tester.tap(statsTab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(stats.calls.length, greaterThan(calls));
    expect(find.byType(ValueSkeleton), findsNothing);
    expect(find.byKey(const Key('stats-line-chart')), findsOneWidget);
    stats.completeAll();
    await tester.pumpAndSettle();
  });
}
