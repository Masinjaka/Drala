import 'package:budgets/features/home/presentation/widgets/home_calendar_header.dart';
import 'package:budgets/features/home/presentation/widgets/home_month_calendar.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_strip.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final date = DateTime(2026, 7, 16);

  testWidgets('capitalizes localized month and compact weekday labels',
      (tester) async {
    await tester.pumpWidget(
      _frenchApp(
        Column(
          children: [
            HomeCalendarHeader(
              focusedDay: date,
              onPeriodPressed: () {},
              onPrevious: null,
              onNext: null,
            ),
            HomeWeekStrip(
              selectedDate: date,
              today: date,
              onDateSelected: (_) {},
            ),
          ],
        ),
      ),
    );

    expect(find.text('Juillet 2026'), findsOneWidget);
    expect(find.text('Dim.'), findsOneWidget);
    expect(find.text('Lun.'), findsOneWidget);
  });

  testWidgets('capitalizes localized expanded weekday labels', (tester) async {
    await tester.pumpWidget(
      _frenchApp(
        HomeMonthCalendar(
          focusedDay: date,
          selectedDay: date,
          today: date,
          activityDates: const {},
          onDaySelected: (_) {},
          onPageChanged: (_) {},
        ),
      ),
    );

    expect(find.text('Dim.'), findsOneWidget);
    expect(find.text('Lun.'), findsOneWidget);
    expect(find.text('Mar.'), findsOneWidget);
  });
}

Widget _frenchApp(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
