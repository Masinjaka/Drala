import 'package:animated_digit/animated_digit.dart';
import 'package:budgets/features/home/presentation/widgets/animated_compact_amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('rolls formatted digits when the amount changes', (tester) async {
    var amount = 1000;
    var completed = 0;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return AnimatedCompactAmount(
              value: amount,
              style: const TextStyle(fontSize: 16),
              onCompleted: () => completed++,
            );
          },
        ),
      ),
    );
    await tester.pump();
    var counter = tester.widget<AnimatedDigitWidget>(
      find.byType(AnimatedDigitWidget),
    );
    expect(counter.controller?.value, 1);
    expect(counter.suffix, 'K');
    expect(counter.firstScrollAnimate, isFalse);

    await tester.pump(const Duration(milliseconds: 800));
    expect(completed, 1);

    update(() => amount = 2000);
    await tester.pump();
    counter = tester.widget<AnimatedDigitWidget>(
      find.byType(AnimatedDigitWidget),
    );
    expect(counter.controller?.value, 2);

    await tester.pump(const Duration(milliseconds: 799));
    expect(completed, 1);
    await tester.pump(const Duration(milliseconds: 1));
    expect(completed, 2);
  });
}
