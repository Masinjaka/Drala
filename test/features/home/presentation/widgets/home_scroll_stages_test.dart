import 'package:budgets/features/home/presentation/widgets/home_week_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_scroll_test_app.dart';

void main() {
  testWidgets(
      'banner translates with scroll; continued drag collapses controls',
      (tester) async {
    await pumpHomeScrollApp(tester);
    final header = tester.getRect(find.byKey(const Key('fixed-header')));
    final composer = tester.getRect(find.byKey(const Key('fixed-composer')));
    final banner =
        find.byKey(const Key('home-scrolling-banner'), skipOffstage: false);
    final initialBanner = tester.getRect(banner);
    final viewportTop = tester.getTopLeft(transactions).dy;
    final gesture = await startListGesture(tester);
    await moveList(tester, gesture, -80);
    final position = transactionPosition(tester);
    expect(position.pixels, inExclusiveRange(0, 138));
    expect(tester.getSize(banner).height, initialBanner.height);
    expect(tester.getTopLeft(banner).dy,
        closeTo(initialBanner.top - position.pixels, 0.01));
    expect(revealHeight(tester, 'home-calendar-header-reveal'), 49);
    final paused = tester.getRect(banner);
    await tester.pump(const Duration(seconds: 1));
    expect(tester.getRect(banner), paused);

    await moveList(tester, gesture, -110);
    expect(tester.getBottomLeft(banner).dy, lessThanOrEqualTo(viewportTop));
    expect(tester.getTopLeft(find.byKey(const Key('home-week-panel'))).dy,
        closeTo(viewportTop, 0.01));
    expect(revealHeight(tester, 'home-calendar-header-reveal'),
        inExclusiveRange(0, 49));
    final controls = revealHeight(tester, 'home-calendar-header-reveal');
    await tester.pump(const Duration(seconds: 1));
    expect(revealHeight(tester, 'home-calendar-header-reveal'), controls);

    await moveList(tester, gesture, -120);
    await finishListGesture(tester, gesture);
    expect(revealHeight(tester, 'home-calendar-header-reveal'), 0);
    expect(revealHeight(tester, 'home-calendar-toggle-reveal'), 8);
    expect(tester.getSize(find.byType(HomeWeekTransition)).height, 64);
    expect(tester.getRect(find.byKey(const Key('fixed-header'))), header);
    expect(tester.getRect(find.byKey(const Key('fixed-composer'))), composer);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reverse scroll reveals controls but banner stays above viewport',
      (tester) async {
    await pumpHomeScrollApp(tester);
    await scrollList(tester, -450);
    expect(revealHeight(tester, 'home-calendar-header-reveal'), 0);
    await scrollList(tester, 160);
    expect(revealHeight(tester, 'home-calendar-header-reveal'), greaterThan(0));
    final banner =
        find.byKey(const Key('home-scrolling-banner'), skipOffstage: false);
    expect(tester.getBottomLeft(banner).dy,
        lessThanOrEqualTo(tester.getTopLeft(transactions).dy));
    await scrollList(tester, 70);
    expect(transactionPosition(tester).pixels, greaterThan(138));
    expect(tester.getBottomLeft(banner).dy,
        lessThanOrEqualTo(tester.getTopLeft(transactions).dy));
    await scrollList(tester, 400);
    expect(transactionPosition(tester).pixels, 0);
    expect(banner.hitTestable(), findsOneWidget);
    expect(revealHeight(tester, 'home-calendar-header-reveal'), 49);
    expect(tester.takeException(), isNull);
  });

  testWidgets('fling momentum naturally scrolls through both sections',
      (tester) async {
    await pumpHomeScrollApp(tester);
    await tester.fling(transactions, const Offset(0, -240), 2000);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(transactionPosition(tester).pixels, greaterThan(219));
    expect(revealHeight(tester, 'home-calendar-header-reveal'), 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('small reverse movement moves banner back by the same distance',
      (tester) async {
    await pumpHomeScrollApp(tester);
    final gesture = await startListGesture(tester);
    await moveList(tester, gesture, -80);
    final banner = find.byKey(const Key('home-scrolling-banner'));
    final before = tester.getTopLeft(banner).dy;
    final offset = transactionPosition(tester).pixels;
    await moveList(tester, gesture, 20);
    expect(tester.getTopLeft(banner).dy - before,
        closeTo(offset - transactionPosition(tester).pixels, 0.01));
    expect(transactionPosition(tester).pixels, greaterThan(0));
    await finishListGesture(tester, gesture);
    expect(tester.takeException(), isNull);
  });
}
