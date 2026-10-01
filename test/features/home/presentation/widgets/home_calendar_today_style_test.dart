import 'package:budgets/features/home/presentation/widgets/home_month_calendar.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  final today = DateTime(2026, 7, 16);
  final selectedDate = DateTime(2026, 7, 15);

  testWidgets('week strip does not outline today when another day is selected',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeWeekStrip(
            selectedDate: selectedDate,
            today: today,
            onDateSelected: (_) {},
          ),
        ),
      ),
    );

    final todayCell = tester.widget<InkWell>(
      find.byKey(const Key('home-week-day-2026-07-16')),
    );
    final todayDecoration = (todayCell.child! as Container).decoration;
    final selectedCell = tester.widget<Container>(
      find.byKey(const Key('home-week-selected-day')),
    );
    final selectedDecoration = selectedCell.decoration as BoxDecoration;

    expect((todayDecoration! as BoxDecoration).border, isNull);
    expect(selectedDecoration.border, isNotNull);
  });

  testWidgets('week strip greys out future day numbers', (tester) async {
    const disabledColor = Color(0xFF909090);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(disabledColor: disabledColor),
        home: Scaffold(
          body: HomeWeekStrip(
            selectedDate: selectedDate,
            today: today,
            onDateSelected: (_) {},
          ),
        ),
      ),
    );

    final futureDay = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const Key('home-week-day-2026-07-17')),
        matching: find.text('17'),
      ),
    );
    final todayLabel = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const Key('home-week-day-2026-07-16')),
        matching: find.text('16'),
      ),
    );

    expect(futureDay.style?.color, disabledColor);
    expect(todayLabel.style?.color, isNull);
  });

  testWidgets('month calendar only highlights the selected day',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeMonthCalendar(
            focusedDay: today,
            selectedDay: selectedDate,
            today: today,
            activityDates: const {},
            onDaySelected: (_) {},
            onPageChanged: (_) {},
          ),
        ),
      ),
    );

    final calendar = tester.widget<TableCalendar<DateTime>>(
      find.byType(TableCalendar<DateTime>),
    );

    expect(calendar.calendarStyle.isTodayHighlighted, isFalse);
    expect(
      (calendar.calendarStyle.selectedDecoration as BoxDecoration).border,
      isNotNull,
    );
  });
}
