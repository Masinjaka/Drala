import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_scroll_test_app.dart';

void main() {
  for (final physics in [
    const ClampingScrollPhysics(),
    const BouncingScrollPhysics(),
  ]) {
    testWidgets('calendar reveal drag holds banner with $physics',
        (tester) async {
      await pumpHomeScrollApp(tester, physics: physics);
      await scrollList(tester, -320);
      final first = await startListGesture(tester);
      await moveList(tester, first, 350);
      expect(transactionPosition(tester).pixels, 138);
      expect(revealHeight(tester, 'home-calendar-header-reveal'), 49);
      await moveList(tester, first, 50);
      expect(transactionPosition(tester).pixels, 138);
      await finishListGesture(tester, first);
      expect(transactionPosition(tester).pixels, 138);

      final second = await startListGesture(tester);
      await moveList(tester, second, 70);
      final pixels = transactionPosition(tester).pixels;
      expect(pixels, inExclusiveRange(0, 138));
      final banner = find.byKey(const Key('home-scrolling-banner'));
      expect(tester.getSize(banner).height, 138);
      expect(tester.getTopLeft(banner).dy,
          closeTo(tester.getTopLeft(transactions).dy - pixels, 0.01));
      await finishListGesture(tester, second);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('reveal fling cannot carry banner past the gesture boundary',
      (tester) async {
    await pumpHomeScrollApp(tester);
    await scrollList(tester, -600);
    await tester.fling(transactions, const Offset(0, 300), 2000);
    await tester.pumpAndSettle();
    expect(transactionPosition(tester).pixels, 138);
    expect(revealHeight(tester, 'home-calendar-header-reveal'), 49);
    await scrollList(tester, 180);
    expect(transactionPosition(tester).pixels, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('second reverse gesture in the middle does not summon banner',
      (tester) async {
    await pumpHomeScrollApp(tester);
    await scrollList(tester, -1000);
    await scrollList(tester, 220);
    expect(revealHeight(tester, 'home-calendar-header-reveal'), 49);
    await scrollList(tester, 100);
    expect(transactionPosition(tester).pixels, greaterThan(138));
    expect(find.byKey(const Key('home-scrolling-banner')).hitTestable(),
        findsNothing);
    expect(tester.takeException(), isNull);
  });
}
