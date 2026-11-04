import 'package:animated_digit/animated_digit.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('stats use banner-style rolling digits with full grouped amounts',
      (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      var value = 150000;
      late StateSetter update;
      await tester.pumpWidget(MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(body: StatefulBuilder(builder: (context, setState) {
            update = setState;
            return StatsAmount(value: value, currencyCode: 'MGA');
          }))));
      await tester.pumpAndSettle();
      var counter =
          tester.widget<AnimatedDigitWidget>(find.byType(AnimatedDigitWidget));
      expect(counter.controller!.value, 150000);
      expect(counter.enableSeparator, isTrue);
      expect(counter.separateSymbol, ',');
      expect(counter.suffix, '');
      expect(find.bySemanticsLabel('Ar 150,000'), findsOneWidget);
      update(() => value = 150075);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 100));
      final digits = tester.stateList<ScrollableState>(find.descendant(
          of: find.byType(AnimatedDigitWidget),
          matching: find.byType(Scrollable)));
      expect(digits.any((digit) => digit.position.isScrollingNotifier.value),
          isTrue);
      await tester.pumpAndSettle();
      counter =
          tester.widget<AnimatedDigitWidget>(find.byType(AnimatedDigitWidget));
      expect(counter.controller!.value, 150075);
      expect(find.bySemanticsLabel('Ar 150,075'), findsOneWidget);
      update(() => value = -30);
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Ar -30'), findsOneWidget);
      update(() => value = 0);
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Ar 0'), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('reduced motion shows the final grouped amount immediately',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: const Scaffold(
                body: StatsAmount(value: 150000, currencyCode: 'MGA')))));
    expect(find.byType(AnimatedDigitWidget), findsNothing);
    expect(find.text('150,000'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
