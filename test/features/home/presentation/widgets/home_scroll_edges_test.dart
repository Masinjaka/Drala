import 'package:budgets/features/home/presentation/widgets/home_month_calendar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_scroll_test_app.dart';

void main() {
  for (final count in [0, 1]) {
    testWidgets('short list with $count entries can scroll both sections away',
        (tester) async {
      await pumpHomeScrollApp(tester, count: count);
      await scrollList(tester, -300);
      expect(transactionPosition(tester).pixels, greaterThanOrEqualTo(219));
      expect(revealHeight(tester, 'home-calendar-header-reveal'), 0);
      expect(revealHeight(tester, 'home-calendar-toggle-reveal'), 8);
      await scrollList(tester, 350);
      expect(transactionPosition(tester).pixels, 138);
      expect(revealHeight(tester, 'home-calendar-header-reveal'), 49);
      await scrollList(tester, 180);
      expect(transactionPosition(tester).pixels, 0);
      expect(find.byKey(const Key('home-scrolling-banner')).hitTestable(),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('bounce ends with days pinned after an upward fling',
      (tester) async {
    await pumpHomeScrollApp(tester,
        count: 1, physics: const BouncingScrollPhysics());
    await tester.fling(transactions, const Offset(0, -300), 800);
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(const Key('home-week-panel'))).dy,
        closeTo(tester.getTopLeft(transactions).dy, 0.01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('month stays expanded while scrolling and preserves focused date',
      (tester) async {
    await pumpHomeScrollApp(tester);
    await tester.tap(find.byKey(const Key('calendar-view-toggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('home-previous-week')));
    await tester.pumpAndSettle();
    expect(find.text('August 2026'), findsOneWidget);
    await scrollList(tester, -650);
    expect(find.byType(HomeMonthCalendar), findsOneWidget);
    expect(revealHeight(tester, 'home-calendar-header-reveal'), 0);
    await scrollList(tester, 400);
    expect(find.text('August 2026').hitTestable(), findsOneWidget);
    expect(find.byType(HomeMonthCalendar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wheel movement uses the same continuous scroll offset',
      (tester) async {
    await pumpHomeScrollApp(tester);
    Future<void> wheel(double dy) =>
        tester.sendEventToBinding(PointerScrollEvent(
            position: tester.getCenter(transactions),
            scrollDelta: Offset(0, dy)));
    await wheel(60);
    await tester.pumpAndSettle();
    expect(transactionPosition(tester).pixels, 60);
    expect(revealHeight(tester, 'home-calendar-header-reveal'), 49);
    await wheel(100);
    await tester.pumpAndSettle();
    expect(revealHeight(tester, 'home-calendar-header-reveal'),
        inExclusiveRange(0, 49));
    await wheel(100);
    await tester.pumpAndSettle();
    expect(revealHeight(tester, 'home-calendar-header-reveal'), 0);
    await wheel(-300);
    await tester.pumpAndSettle();
    expect(transactionPosition(tester).pixels, 0);
    expect(find.byKey(const Key('home-scrolling-banner')).hitTestable(),
        findsOneWidget);
  });

  testWidgets('reduced motion still follows finger movement', (tester) async {
    await pumpHomeScrollApp(tester, reduceMotion: true);
    await scrollList(tester, -180);
    expect(revealHeight(tester, 'home-calendar-header-reveal'),
        inExclusiveRange(0, 49));
    expect(tester.takeException(), isNull);
  });
}
