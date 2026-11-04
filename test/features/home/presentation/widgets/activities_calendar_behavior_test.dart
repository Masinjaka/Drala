import 'package:budgets/features/home/presentation/widgets/home_calendar_header.dart';
import 'package:budgets/features/home/presentation/widgets/home_month_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/activities_fixture.dart';

void main() {
  testWidgets(
      'redesigned calendar animates between week and month in both directions',
      (tester) async {
    await _open(tester);
    final panel = find.byKey(const Key('home-week-panel'));
    final toggle = find.byKey(const Key('calendar-view-toggle'));
    final week = tester.getSize(panel).height;
    await tester.tap(toggle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 130));
    final halfway = tester.getSize(panel).height;
    expect(halfway, greaterThan(week));
    await tester.pumpAndSettle();
    final month = tester.getSize(panel).height;
    expect(month, greaterThan(halfway));
    expect(find.byType(HomeMonthCalendar), findsOneWidget);
    await tester.tap(toggle);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 130));
    expect(tester.getSize(panel).height, inExclusiveRange(week, month));
    await tester.pumpAndSettle();
    expect(tester.getSize(panel).height, week);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'calendar controls collapse on scroll and return without moving the heading',
      (tester) async {
    await _open(tester);
    final panel = find.byKey(const Key('home-week-panel'));
    final before = tester.getSize(panel).height;
    final title = tester.getTopLeft(find.text('Activities').first).dy;
    final scroll = find.byKey(const Key('transaction-scroll-view'));
    await tester.drag(scroll, const Offset(0, -180));
    await tester.pumpAndSettle();
    expect(tester.getSize(panel).height, lessThan(before));
    expect(tester.getTopLeft(find.text('Activities').first).dy, title);
    await tester.drag(scroll, const Offset(0, 240));
    await tester.pumpAndSettle();
    expect(tester.getSize(panel).height, before);
    expect(tester.takeException(), isNull);
  });

  testWidgets('week arrows retain animated horizontal paging', (tester) async {
    await _open(tester);
    final day = find.byKey(const Key('home-week-day-2026-09-20'));
    final before = tester.getTopLeft(day).dx;
    await tester.tap(find.byKey(const Key('home-previous-week')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getTopLeft(day).dx, greaterThan(before));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-week-day-2026-09-13')), findsOneWidget);
    await tester.drag(find.byKey(const Key('home-week-swipe-surface')),
        const Offset(-350, 0));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-week-day-2026-09-26')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'calendar and navigation suppress tap ink without disabling their actions',
      (tester) async {
    await _open(tester);
    for (final target in [
      find.byType(HomeCalendarHeader),
      find.byKey(const ValueKey('home-navigation-1'))
    ]) {
      final theme = Theme.of(tester.element(target));
      expect(theme.splashFactory, NoSplash.splashFactory);
      expect(theme.highlightColor.a, 0);
      expect(theme.splashColor.a, 0);
      expect(
          theme.iconButtonTheme.style!.overlayColor!
              .resolve({WidgetState.pressed})!.a,
          0);
    }
    await tester.tap(find.byKey(const Key('calendar-view-toggle')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeMonthCalendar), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('home-navigation-2')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chat-input-container')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'reduced motion retains the month toggle without animating its height',
      (tester) async {
    await _open(tester, reducedMotion: true);
    final panel = find.byKey(const Key('home-week-panel'));
    final before = tester.getSize(panel).height;
    await tester.tap(find.byKey(const Key('calendar-view-toggle')));
    await tester.pump();
    expect(tester.getSize(panel).height, before + 160);
    expect(find.byType(HomeMonthCalendar), findsOneWidget);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _open(WidgetTester tester, {bool reducedMotion = false}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 917);
  addTearDown(tester.view.reset);
  final fixture = ActivitiesFixture();
  addTearDown(fixture.dispose);
  await fixture.load();
  await tester.pumpWidget(fixture.app(reducedMotion: reducedMotion));
  await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
  await tester.pumpAndSettle();
}
