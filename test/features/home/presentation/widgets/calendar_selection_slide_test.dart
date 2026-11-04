import 'package:budgets/features/home/presentation/widgets/home_month_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/activities_fixture.dart';

void main() {
  testWidgets(
      'week highlight glides from its current position and retargets rapid taps',
      (tester) async {
    await _open(tester);
    final highlight = find.byKey(const Key('calendar-selection-highlight'));
    final before = tester.getRect(highlight);
    final target =
        tester.getCenter(find.byKey(const Key('home-week-day-2026-09-23')));
    await tester.tap(find.byKey(const Key('home-week-day-2026-09-23')));
    await tester.pump();
    expect(tester.getRect(highlight), before);
    await tester.pump(const Duration(milliseconds: 130));
    final middle = tester.getCenter(highlight);
    expect(middle.dx, inExclusiveRange(target.dx, before.center.dx));
    await tester.tap(find.byKey(const Key('home-week-day-2026-09-24')));
    await tester.pump();
    expect(tester.getCenter(highlight).dx, closeTo(middle.dx, .01));
    await tester.pumpAndSettle();
    expect(
        tester.getCenter(highlight).dx,
        closeTo(
            tester
                .getCenter(find.byKey(const Key('home-week-day-2026-09-24')))
                .dx,
            .01));
    expect(
        find.byKey(const Key('calendar-selection-highlight')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'month highlight glides between rows and follows horizontal month paging',
      (tester) async {
    await _open(tester);
    await tester.tap(find.byKey(const Key('calendar-view-toggle')));
    await tester.pumpAndSettle();
    final month = find.byType(HomeMonthCalendar);
    final highlight = find.descendant(
        of: month,
        matching: find.byKey(const Key('calendar-selection-highlight')));
    final before = tester.getCenter(highlight);
    final day = find
        .descendant(of: month, matching: find.text('9'))
        .hitTestable()
        .first;
    final target = tester.getCenter(day);
    await tester.tap(day);
    await tester.pump();
    expect(tester.getCenter(highlight), before);
    await tester.pump(const Duration(milliseconds: 130));
    final middle = tester.getCenter(highlight);
    expect(middle.dy, inExclusiveRange(target.dy, before.dy));
    expect(middle.dx, inExclusiveRange(target.dx, before.dx));
    await tester.pumpAndSettle();
    expect(tester.getCenter(highlight).dx, closeTo(target.dx, .01));
    expect(tester.getCenter(highlight).dy, closeTo(target.dy, .01));
    await tester.tap(find.byKey(const Key('home-previous-week')));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(highlight).dx,
        greaterThan(tester.getTopRight(month).dx));
    await tester.tap(find.byKey(const Key('home-next-week')));
    await tester.pumpAndSettle();
    expect(tester.getCenter(highlight).dx, closeTo(target.dx, .01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion moves the highlight immediately in both modes',
      (tester) async {
    await _open(tester, reducedMotion: true);
    await tester.tap(find.byKey(const Key('home-week-day-2026-09-23')));
    await tester.pump();
    final highlight = find.byKey(const Key('calendar-selection-highlight'));
    expect(
        tester.getCenter(highlight).dx,
        closeTo(
            tester
                .getCenter(find.byKey(const Key('home-week-day-2026-09-23')))
                .dx,
            .01));
    await tester.tap(find.byKey(const Key('calendar-view-toggle')));
    await tester.pumpAndSettle();
    final day = find
        .descendant(
            of: find.byType(HomeMonthCalendar), matching: find.text('9'))
        .hitTestable()
        .first;
    final target = tester.getCenter(day);
    await tester.tap(day);
    await tester.pump();
    expect(tester.getCenter(highlight).dy, closeTo(target.dy, .01));
    expect(tester.getCenter(highlight).dx, closeTo(target.dx, .01));
    expect(tester.takeException(), isNull);
  });
}

Future<void> _open(WidgetTester tester, {bool reducedMotion = false}) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final fixture = ActivitiesFixture();
  addTearDown(fixture.dispose);
  await fixture.load();
  await tester.pumpWidget(fixture.app(reducedMotion: reducedMotion));
  await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
  await tester.pumpAndSettle();
}
