import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/activities_fixture.dart';

void main() {
  testWidgets(
      'pinned calendar gains a smooth bottom gap and restores its resting spacing',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 917);
    addTearDown(tester.view.reset);
    final fixture = ActivitiesFixture();
    addTearDown(fixture.dispose);
    await fixture.load();
    await tester.pumpWidget(fixture.app());
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();
    final calendar = find.byKey(const Key('home-week-panel'));
    final background = find.byKey(const Key('calendar-pinned-background'));
    final scrollable = tester.state<ScrollableState>(find
        .descendant(
            of: find.byKey(const Key('transaction-scroll-view')),
            matching: find.byType(Scrollable))
        .first);
    double gap() =>
        tester.getBottomLeft(background).dy - tester.getBottomLeft(calendar).dy;
    final restingHeight = tester.getSize(calendar).height;
    expect(gap(), closeTo(0, .01));
    scrollable.position.jumpTo(26);
    await tester.pump();
    expect(
        gap(), inExclusiveRange(0, AppActivitiesTheme.calendarPinnedBottomGap));
    scrollable.position.jumpTo(69);
    await tester.pumpAndSettle();
    expect(gap(), closeTo(AppActivitiesTheme.calendarPinnedBottomGap, .01));
    scrollable.position.jumpTo(0);
    await tester.pumpAndSettle();
    expect(gap(), closeTo(0, .01));
    expect(tester.getSize(calendar).height, restingHeight);
    expect(tester.takeException(), isNull);
  });
}
