import 'package:budgets/core/theme.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_page_header.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets('buttons suppress ink and pressed overlays dark=$dark',
        (tester) async {
      var presses = 0;
      void press() => presses++;
      final buttons = <Widget>[
        ElevatedButton(onPressed: press, child: const Text('Elevated')),
        FilledButton(onPressed: press, child: const Text('Filled')),
        OutlinedButton(onPressed: press, child: const Text('Outlined')),
        TextButton(onPressed: press, child: const Text('Text')),
        IconButton(onPressed: press, icon: const Icon(Icons.add)),
        CustomButton(text: 'Custom', onPressed: press),
        EmptyStateAction(label: 'Create', onPressed: press),
      ];
      for (var index = 0; index < buttons.length; index++) {
        await tester.pumpWidget(MaterialApp(
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: Scaffold(
              body: Center(
                  child: SizedBox(
                      width: 200,
                      child: KeyedSubtree(
                          key: ValueKey(index), child: buttons[index])))),
        ));
        await tester.pumpAndSettle();
        final ink = find.descendant(
            of: find.byKey(ValueKey(index)), matching: find.byType(InkWell));
        final gesture = await tester.startGesture(tester.getCenter(ink));
        await tester.pump(const Duration(milliseconds: 80));
        final feedback = tester.widget<InkWell>(ink);
        expect(feedback.splashFactory, NoSplash.splashFactory);
        expect(feedback.overlayColor!.resolve({WidgetState.pressed}),
            Colors.transparent);
        await gesture.up();
        await tester.pumpAndSettle();
        expect(presses, index + 1);
      }
    });

    testWidgets('envelope year and add controls have no ripple dark=$dark',
        (tester) async {
      var picks = 0;
      var adds = 0;
      await tester.pumpWidget(MaterialApp(
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        home: Scaffold(
            body: EnvelopePageHeader(
                month: DateTime(2026, 10),
                showBackButton: false,
                onPickMonth: () => picks++,
                onAdd: () => adds++)),
      ));
      for (final key in ['envelope-pick-month', 'detail-add-button']) {
        final ink = find.descendant(
            of: find.byKey(Key(key)), matching: find.byType(InkWell));
        final gesture = await tester.startGesture(tester.getCenter(ink));
        await tester.pump(const Duration(milliseconds: 80));
        final feedback = tester.widget<InkWell>(ink);
        expect(feedback.splashFactory, NoSplash.splashFactory);
        expect(feedback.overlayColor!.resolve({WidgetState.pressed}),
            Colors.transparent);
        await gesture.up();
        await tester.pumpAndSettle();
      }
      expect(picks, 1);
      expect(adds, 1);
    });
  }
}
