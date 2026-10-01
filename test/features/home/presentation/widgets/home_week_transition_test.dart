import 'package:budgets/features/home/presentation/widgets/home_week_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_scroll_test_app.dart';

void main() {
  testWidgets('swipes horizontally between weeks', (tester) async {
    var focusedDate = DateTime(2026, 7, 16);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => HomeWeekTransition(
              focusedDate: focusedDate,
              selectedDate: DateTime(2026, 7, 16),
              today: DateTime(2026, 8, 30),
              activityDates: const {},
              onDateSelected: (_) {},
              onPreviousWeek: () => setState(
                () => focusedDate = focusedDate.subtract(
                  const Duration(days: 7),
                ),
              ),
              onNextWeek: () => setState(
                () => focusedDate = focusedDate.add(const Duration(days: 7)),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('home-week-day-2026-07-12')), findsOneWidget);

    final currentWeek = find.byKey(const Key('home-week-day-2026-07-12'));
    final initialX = tester.getTopLeft(currentWeek).dx;
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('home-week-swipe-surface'))),
    );
    await gesture.moveBy(const Offset(-60, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-60, 0));
    await tester.pump();
    expect(tester.getTopLeft(currentWeek).dx, lessThan(initialX));

    await gesture.moveBy(const Offset(-400, 0));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-week-day-2026-07-19')), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('home-week-swipe-surface')),
      const Offset(500, 0),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-week-day-2026-07-12')), findsOneWidget);
  });

  testWidgets('ignores swipes when the requested direction is unavailable',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeWeekTransition(
            focusedDate: DateTime(2026, 7, 16),
            selectedDate: DateTime(2026, 7, 16),
            today: DateTime(2026, 7, 16),
            activityDates: const {},
            onDateSelected: (_) {},
            onPreviousWeek: () {},
            onNextWeek: null,
          ),
        ),
      ),
    );

    await tester.drag(
      find.byKey(const Key('home-week-swipe-surface')),
      const Offset(-250, 0),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-week-day-2026-07-12')), findsOneWidget);
  });

  testWidgets('animates when an external week button changes focus',
      (tester) async {
    var focusedDate = DateTime(2026, 7, 16);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                TextButton(
                  onPressed: () => setState(
                    () => focusedDate = focusedDate.add(
                      const Duration(days: 7),
                    ),
                  ),
                  child: const Text('Next week'),
                ),
                HomeWeekTransition(
                  focusedDate: focusedDate,
                  selectedDate: DateTime(2026, 7, 16),
                  today: DateTime(2026, 8, 30),
                  activityDates: const {},
                  onDateSelected: (_) {},
                  onPreviousWeek: () {},
                  onNextWeek: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final currentWeek = find.byKey(const Key('home-week-day-2026-07-12'));
    final initialX = tester.getTopLeft(currentWeek).dx;
    await tester.tap(find.text('Next week'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.getTopLeft(currentWeek).dx, lessThan(initialX));

    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-week-day-2026-07-19')), findsOneWidget);
  });

  testWidgets('header arrows animate the weekly PageView', (tester) async {
    await pumpHomeScrollApp(tester, count: 0);
    final pageView = tester.widget<PageView>(find.byType(PageView));
    final initialPage = pageView.controller!.page!;

    await tester.tap(find.byKey(const Key('home-previous-week')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final animatedPage = pageView.controller!.page!;
    expect(animatedPage, lessThan(initialPage));
    expect(animatedPage, greaterThan(initialPage - 1));

    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-week-day-2026-09-13')), findsOneWidget);

    final previousPage = pageView.controller!.page!;
    await tester.tap(find.byKey(const Key('home-next-week')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final returningPage = pageView.controller!.page!;
    expect(returningPage, greaterThan(previousPage));
    expect(returningPage, lessThan(previousPage + 1));

    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-week-day-2026-09-20')), findsOneWidget);
  });
}
