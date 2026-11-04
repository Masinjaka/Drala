import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/activities_fixture.dart';

void main() {
  testWidgets('navigation morphs in both directions and keeps the chat draft',
      (tester) async {
    final fixture = ActivitiesFixture();
    addTearDown(fixture.dispose);
    await fixture.load();
    await tester.pumpWidget(fixture.app());
    await tester.pumpAndSettle();
    final surface = find.byKey(const Key('home-navigation-surface'));
    final collapsed = tester.getSize(surface).height;
    expect(find.byKey(const Key('chat-input-container')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    final middle = tester.getSize(surface).height;
    expect(middle, greaterThan(collapsed));
    await tester.pumpAndSettle();
    final expanded = tester.getSize(surface).height;
    expect(expanded, greaterThan(middle));
    expect(find.byKey(const Key('chat-input-container')), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Coffee 1200');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('home-navigation-2')));
    await tester.pumpAndSettle();
    expect(tester.getSize(surface).height, collapsed);
    expect(find.byKey(const Key('chat-input-container')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();
    expect(find.text('Coffee 1200'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('guest and reduced-motion modes keep their expected navigation',
      (tester) async {
    final fixture = ActivitiesFixture();
    addTearDown(fixture.dispose);
    await fixture.load();
    await tester.pumpWidget(fixture.app(manualOnly: true, reducedMotion: true));
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chat-input-container')), findsNothing);
    expect(find.byKey(const Key('guest-manual-entry-fab')), findsOneWidget);
    expect(
        tester.getSize(find.byKey(const Key('home-navigation-surface'))).height,
        56);
    expect(tester.takeException(), isNull);
  });

  testWidgets('composer remains above the keyboard on a narrow phone',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 720);
    addTearDown(tester.view.reset);
    final fixture = ActivitiesFixture();
    addTearDown(fixture.dispose);
    await fixture.load();
    await tester.pumpWidget(fixture.app(scale: 1.3));
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(
        tester
            .getBottomLeft(find.byKey(const Key('home-navigation-surface')))
            .dy,
        lessThanOrEqualTo(420));
    expect(tester.takeException(), isNull);
  });
  testWidgets('signed-in navigation skips the morph for reduced motion',
      (tester) async {
    final fixture = ActivitiesFixture();
    addTearDown(fixture.dispose);
    await fixture.load();
    await tester.pumpWidget(fixture.app(reducedMotion: true));
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pump();
    expect(
        tester.getSize(find.byKey(const Key('home-navigation-surface'))).height,
        122);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
  testWidgets('rapid tab changes leave one composer in the correct destination',
      (tester) async {
    final fixture = ActivitiesFixture();
    addTearDown(fixture.dispose);
    await fixture.load();
    await tester.pumpWidget(fixture.app());
    for (final index in [1, 2, 1, 4, 1]) {
      await tester.tap(find.byKey(ValueKey('home-navigation-$index')));
      await tester.pump(const Duration(milliseconds: 70));
    }
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chat-input-container')), findsOneWidget);
    expect(find.byKey(const Key('home-navigation-surface')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
