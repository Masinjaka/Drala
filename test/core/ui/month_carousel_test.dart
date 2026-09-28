import 'package:budgets/core/ui/month_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses no ripple and makes the selected month bold',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MonthCarousel(
            month: DateTime(2026, 9),
            onChanged: (_) {},
            canGoNext: true,
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byKey(const Key('month-carousel')),
        matching: find.byType(InkWell),
      ),
      findsNothing,
    );
    final selectedStyle = tester
        .widgetList<AnimatedDefaultTextStyle>(
          find.byType(AnimatedDefaultTextStyle),
        )
        .singleWhere((widget) => widget.style.fontSize == 16)
        .style;
    expect(selectedStyle.fontWeight, FontWeight.w700);
  });

  testWidgets('selects months with horizontal swipes', (tester) async {
    final offsets = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: MonthCarousel(
              month: DateTime(2026, 9),
              onChanged: offsets.add,
              canGoNext: true,
            ),
          ),
        ),
      ),
    );

    await tester.drag(
      find.byKey(const Key('month-carousel')),
      const Offset(180, 0),
    );
    await tester.pumpAndSettle();
    expect(offsets.single, isNegative);
    final backwardOffset = offsets.single;

    await tester.drag(
      find.byKey(const Key('month-carousel')),
      const Offset(-180, 0),
    );
    await tester.pumpAndSettle();
    expect(offsets, [backwardOffset, -backwardOffset]);
  });
}
