import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/activities_fixture.dart';

void main() {
  testWidgets(
      'weekly navigation and day selection load the selected activity date',
      (tester) async {
    final fixture = ActivitiesFixture();
    addTearDown(fixture.dispose);
    await fixture.load();
    await tester.pumpWidget(fixture.app());
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('home-week-day-2026-09-23')));
    await tester.pumpAndSettle();
    expect(fixture.repository.requestedDate, DateTime(2026, 9, 23));
    final selected = find.byKey(const Key('home-week-selected-day'));
    expect(find.descendant(of: selected, matching: find.text('23')),
        findsOneWidget);
    await tester.tap(find.byKey(const Key('home-previous-week')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home-week-day-2026-09-19')), findsOneWidget);
    await tester.tap(find.byKey(const Key('home-week-day-2026-09-19')));
    await tester.pumpAndSettle();
    expect(fixture.repository.requestedDate, DateTime(2026, 9, 19));
    expect(tester.takeException(), isNull);
  });
}
