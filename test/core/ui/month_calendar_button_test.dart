import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/month_calendar_button.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('month fades and slides in before the year as the button expands',
      (tester) async {
    var showMonth = false;
    var taps = 0;
    late StateSetter update;
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
            body: Center(child: StatefulBuilder(builder: (context, setState) {
          update = setState;
          return MonthCalendarButton(
              month: DateTime(2026, 9),
              maxWidth: 400,
              showMonth: showMonth,
              onPressed: () => taps++,
              buttonKey: const Key('picker'));
        })))));
    const monthKey = Key('calendar-button-month');
    final button = find.byKey(const Key('picker'));
    final initialWidth = tester.getSize(button).width;
    expect(find.byKey(monthKey), findsNothing);
    update(() => showMonth = true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    final animatedWidth = tester.getSize(button).width;
    expect(animatedWidth, greaterThan(initialWidth));
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpAndSettle();
    expect(tester.getSize(button).width, greaterThan(animatedWidth));
    expect(tester.getCenter(find.byKey(monthKey)).dx,
        lessThan(tester.getCenter(find.text('2026')).dx));
    await tester.tap(button);
    expect(taps, 1);
    update(() => showMonth = false);
    await tester.pumpAndSettle();
    expect(find.byKey(monthKey), findsNothing);
    expect(tester.getSize(button).width, closeTo(initialWidth, .1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('localized month fits large text with reduced motion',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
            data: const MediaQueryData(
                disableAnimations: true, textScaler: TextScaler.linear(1.6)),
            child: Scaffold(
                body: Center(
                    child: MonthCalendarButton(
                        month: DateTime(2026, 9),
                        showMonth: true,
                        maxWidth: 110,
                        onPressed: () {},
                        buttonKey: const Key('picker')))))));
    await tester.pump();
    expect(find.text('Sept.'), findsOneWidget);
    expect(tester.widget<Text>(find.text('Sept.')).semanticsLabel, 'Septembre');
    expect(tester.getSize(find.byKey(const Key('picker'))).width,
        lessThanOrEqualTo(110));
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });
}
