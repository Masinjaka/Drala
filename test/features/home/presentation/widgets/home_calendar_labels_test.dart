import 'package:budgets/core/localization/fallback_localization_delegates.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_header.dart';
import 'package:budgets/features/home/presentation/widgets/home_month_calendar.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_strip.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  final date = DateTime(2026, 7, 16);

  setUpAll(() => initializeDateFormatting('mg'));

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

  testWidgets('uses Malagasy date labels for the Malagasy locale',
      (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        locale: const Locale('mg'),
        child: Column(
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

    expect(find.text('Jolay 2026'), findsOneWidget);
    expect(find.text('Alah'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _frenchApp(Widget child) =>
    _localizedApp(locale: const Locale('fr'), child: child);

Widget _localizedApp({required Locale locale, required Widget child}) =>
    MaterialApp(
      locale: locale,
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        const MalagasyMaterialLocalizationsDelegate(),
        const MalagasyCupertinoLocalizationsDelegate(),
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
