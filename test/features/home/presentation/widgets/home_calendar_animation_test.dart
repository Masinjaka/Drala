import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_scroll_test_app.dart';

void main() {
  testWidgets('calendar animates both directions with centered toggle',
      (tester) async {
    await pumpHomeScrollApp(tester);
    final panel = find.byKey(const Key('home-week-panel'));
    final toggle = find.byKey(const Key('calendar-view-toggle'));
    double height() => tester.getSize(panel).height;
    void centered() => expect(
        tester.getCenter(toggle).dx, closeTo(tester.getCenter(panel).dx, 0.01));
    final weekHeight = height();
    centered();
    await tester.tap(toggle);
    await tester.pump();
    expect(height(), weekHeight);
    await tester.pump(const Duration(milliseconds: 130));
    expect(height(), inExclusiveRange(weekHeight, weekHeight + 160));
    centered();
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    final monthHeight = height();
    expect(monthHeight, closeTo(weekHeight + 160, 0.01));
    expect(tester.getSize(toggle).height, 40);
    centered();
    await tester.tap(toggle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 130));
    expect(height(), inExclusiveRange(weekHeight, monthHeight));
    centered();
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(height(), weekHeight);
  });

  testWidgets('reduced motion switches calendar without height animation',
      (tester) async {
    await pumpHomeScrollApp(tester, reduceMotion: true);
    final panel = find.byKey(const Key('home-week-panel'));
    final weekHeight = tester.getSize(panel).height;
    await tester.tap(find.byKey(const Key('calendar-view-toggle')));
    await tester.pump();
    expect(tester.getSize(panel).height, weekHeight + 160);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
