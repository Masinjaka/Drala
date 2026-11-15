import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_balance.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/overview_fixture.dart';

void main() {
  testWidgets(
      'overview is first; activities is second and has no amount banner',
      (tester) async {
    await tester.pumpWidget(overviewFixture());
    await tester.pumpAndSettle();
    expect(find.text('Hi, Masy'), findsOneWidget);
    expect(find.text('Friday, October 23'), findsOneWidget);
    expect(find.byType(HomeOverviewBalance), findsOneWidget);
    expect(find.byType(HomeOverviewTransactionTile), findsNWidgets(4));
    expect(find.text('Ar 2,350,000'), findsOneWidget);
    expect(find.text('+ Ar 300,000'), findsNWidgets(2));
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeOverviewBalance), findsNothing);
    expect(find.text('Available balance'), findsNothing);
    expect(find.byKey(const Key('transaction-scroll-view')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('home-navigation-0')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeOverviewBalance), findsOneWidget);
  });

  testWidgets('See more opens the matching envelopes and activities tabs',
      (tester) async {
    await tester.pumpWidget(overviewFixture());
    await tester.pumpAndSettle();
    await tester.tap(find.text('See more').first);
    await tester.pumpAndSettle();
    expect(find.byType(EnvelopePage), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('home-navigation-0')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('See more').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('See more').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('transaction-scroll-view')), findsOneWidget);
  });

  testWidgets('balance eye hides every amount on the overview', (tester) async {
    final visibility = AmountVisibilityController();
    addTearDown(visibility.dispose);
    await tester.pumpWidget(overviewFixture(visibility: visibility));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('home-overview-visibility')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Ar '), findsNothing);
    expect(find.text('••••'), findsNWidgets(9));
    await tester.tap(find.byKey(const Key('home-overview-visibility')));
    await tester.pumpAndSettle();
    expect(find.text('Ar 2,350,000'), findsOneWidget);
    expect(find.text('••••'), findsNothing);
  });

  testWidgets(
      'recent transactions scroll behind the nav and clear it at the end',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 720);
    const insets = FakeViewPadding(bottom: 34);
    tester.view.padding = insets;
    tester.view.viewPadding = insets;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(overviewFixture());
    await tester.pumpAndSettle();

    final pill =
        tester.getRect(find.byKey(const Key('home-navigation-surface')));
    final scroll = find.byKey(const Key('home-overview-scroll'));
    final last = find.byType(HomeOverviewTransactionTile).last;
    expect(tester.getRect(scroll).bottom, greaterThan(pill.bottom));
    expect(tester.getRect(last).bottom, greaterThan(pill.top));

    await tester.drag(scroll, const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(tester.getRect(last).bottom, lessThan(pill.top));
    expect(tester.takeException(), isNull);
  });

  testWidgets('pulling down at the top refreshes Home transactions',
      (tester) async {
    final repository = overviewEntries();
    await tester.pumpWidget(overviewFixture(entryRepository: repository));
    await tester.pumpAndSettle();
    final originalLoads = repository.monthLoadCount;

    await tester.drag(
        find.byKey(const Key('home-overview-scroll')), const Offset(0, 380));
    await tester.pumpAndSettle();

    expect(repository.monthLoadCount, greaterThan(originalLoads));
    expect(find.byType(HomeOverviewTransactionTile), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  for (final dark in [false, true]) {
    testWidgets('overview fits small screens with large text, dark=$dark',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 640);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(overviewFixture(dark: dark, scale: 1.6));
      await tester.pumpAndSettle();
      await tester.drag(
          find.byKey(const Key('home-overview-scroll')), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('home-navigation-4')), findsOneWidget);
    });
  }
}
