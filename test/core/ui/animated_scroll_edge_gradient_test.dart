import 'package:budgets/core/ui/animated_scroll_edge_gradient.dart';
import 'package:budgets/core/ui/scroll_edge_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget app({required bool visible, bool top = false, bool reduced = false}) =>
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: AnimatedScrollEdgeGradient(visible: visible, top: top),
      ),
    );

double opacity(WidgetTester tester) => tester
    .widget<Opacity>(find.descendant(
        of: find.byType(AnimatedScrollEdgeGradient),
        matching: find.byType(Opacity)))
    .opacity;

void main() {
  for (final top in [true, false]) {
    testWidgets('${top ? 'top' : 'bottom'} fades in and out without snapping',
        (tester) async {
      await tester.pumpWidget(app(visible: false, top: top));
      expect(find.byType(ScrollEdgeGradient), findsNothing);
      await tester.pumpWidget(app(visible: true, top: top));
      await tester.pump(const Duration(milliseconds: 110));
      expect(opacity(tester), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(opacity(tester), 1);

      await tester.pumpWidget(app(visible: false, top: top));
      expect(opacity(tester), 1);
      await tester.pump(const Duration(milliseconds: 110));
      expect(opacity(tester), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(find.byType(ScrollEdgeGradient), findsNothing);
    });
  }

  testWidgets('reversing direction continues from the current opacity',
      (tester) async {
    await tester.pumpWidget(app(visible: false));
    await tester.pumpWidget(app(visible: true));
    await tester.pump(const Duration(milliseconds: 110));
    final halfway = opacity(tester);
    await tester.pumpWidget(app(visible: false));
    expect(opacity(tester), halfway);
    await tester.pump(const Duration(milliseconds: 55));
    expect(opacity(tester), lessThan(halfway));
    await tester.pumpAndSettle();
    expect(find.byType(ScrollEdgeGradient), findsNothing);
  });

  testWidgets('reduced motion changes visibility without animation',
      (tester) async {
    await tester.pumpWidget(app(visible: false, reduced: true));
    await tester.pumpWidget(app(visible: true, reduced: true));
    await tester.pump();
    expect(opacity(tester), 1);
    await tester.pumpWidget(app(visible: false, reduced: true));
    await tester.pump();
    expect(find.byType(ScrollEdgeGradient), findsNothing);
  });
}
