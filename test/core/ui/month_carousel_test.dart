import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/month_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets('centers a stronger month in ${theme.brightness}',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: MonthCarousel(
              month: DateTime(2026, 9),
              onChanged: (_) {},
              canGoNext: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('month-carousel')),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
      final styles = tester
          .widgetList<AnimatedDefaultTextStyle>(
            find.descendant(
              of: find.byKey(const Key('month-carousel')),
              matching: find.byType(AnimatedDefaultTextStyle),
            ),
          )
          .map((widget) => widget.style)
          .toList();
      final active = styles.singleWhere(
        (style) => style.fontWeight == FontWeight.w700,
      );
      final inactive = styles.where((style) => style != active);
      expect(active.color, theme.colorScheme.onSurface);
      expect(active.fontFamily, theme.textTheme.bodyMedium?.fontFamily);
      expect(inactive, isNotEmpty);
      for (final style in inactive) {
        expect(style.fontSize, lessThan(active.fontSize!));
        expect(style.fontWeight, FontWeight.normal);
        expect(style.color?.a, lessThan(active.color!.a));
        expect(style.fontFamily, active.fontFamily);
      }
    });
  }

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
