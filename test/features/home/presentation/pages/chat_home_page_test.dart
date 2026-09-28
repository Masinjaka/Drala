import 'package:animated_digit/animated_digit.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_test_window.dart';

void main() {
  testWidgets('shows the hard-coded dashboard and accepts chat input',
      (tester) async {
    usePhoneWindow(tester);
    await tester.pumpWidget(
      MaterialApp(home: ChatHomePage(today: DateTime(2026, 7, 16))),
    );
    await tester.pumpAndSettle();

    final background = find.byKey(const Key('home-dashboard-background'));
    expect(tester.getTopLeft(background).dx, 0);
    expect(tester.getSize(background).width, 400);
    expect(find.text('1M'), findsOneWidget);
    expect(find.text('All time'), findsNothing);
    expect(find.text('Operations'), findsOneWidget);
    expect(find.text('3 expenses'), findsOneWidget);
    expect(find.text('Burgers & Fries'), findsOneWidget);
    expect(find.text('Gift'), findsOneWidget);
    expect(find.text('Alcohol'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Lunch 12 dollars');

    expect(find.text('Lunch 12 dollars'), findsOneWidget);
  });

  testWidgets('selected week date updates the highlighted day', (tester) async {
    usePhoneWindow(tester);
    await tester.pumpWidget(
      MaterialApp(home: ChatHomePage(today: DateTime(2026, 7, 16))),
    );
    await tester.pumpAndSettle();
    final balanceCounters = tester
        .widgetList<AnimatedDigitWidget>(find.byType(AnimatedDigitWidget))
        .toList();

    await tester.tap(
      find.byKey(const Key('home-week-day-2026-07-15')),
    );
    await tester.pumpAndSettle();

    final selected = find.byKey(const Key('home-week-selected-day'));
    expect(find.descendant(of: selected, matching: find.text('15')),
        findsOneWidget);
    expect(
      tester
          .widgetList<AnimatedDigitWidget>(find.byType(AnimatedDigitWidget))
          .toList(),
      orderedEquals(balanceCounters),
    );
  });

  testWidgets('wide phones keep the home surface edge-to-edge', (tester) async {
    useWidePhoneWindow(tester);
    await tester.pumpWidget(
      MaterialApp(home: ChatHomePage(today: DateTime(2026, 7, 16))),
    );
    await tester.pumpAndSettle();

    final background = find.byKey(const Key('home-dashboard-background'));
    expect(tester.getTopLeft(background).dx, 0);
    expect(tester.getSize(background).width, 484);
  });
}
