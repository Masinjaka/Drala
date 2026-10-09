import 'package:budgets/core/theme.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('choice shrinks while pressed and recovers on release',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Center(
          child: SetupChoice(
            title: 'English',
            selected: false,
            onTap: () => taps++,
          ),
        ),
      ),
    ));

    final gesture =
        await tester.startGesture(tester.getCenter(find.text('English')));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 110));
    final scale = tester.widget<ScaleTransition>(
      find
          .descendant(
            of: find.byType(SetupChoice),
            matching: find.byType(ScaleTransition),
          )
          .first,
    );
    expect(scale.scale.value, closeTo(0.94, 0.01));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(scale.scale.value, closeTo(1, 0.01));
    expect(find.byType(InkWell), findsNothing);
  });
}
