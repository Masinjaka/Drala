import 'package:budgets/core/ui/list_item_entrance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final reduced in [false, true]) {
    testWidgets(
        'replaying list entrance preserves field state and focus, reduced=$reduced',
        (tester) async {
      final controller = TextEditingController();
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      var tab = 0;
      late StateSetter update;
      await tester.pumpWidget(MaterialApp(
          home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: Scaffold(body: StatefulBuilder(builder: (context, setState) {
          update = setState;
          return ListItemEntrance(
              index: 1,
              replayKey: tab,
              child: TextField(controller: controller, focusNode: focus));
        })),
      )));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Preserved');
      final field = tester.state(find.byType(TextField));
      update(() => tab++);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 25));
      await tester.pump(const Duration(milliseconds: 70));
      expect(tester.state(find.byType(TextField)), same(field));
      expect(controller.text, 'Preserved');
      expect(focus.hasFocus, true);
      final fades = find.descendant(
          of: find.byType(ListItemEntrance),
          matching: find.byType(FadeTransition));
      if (reduced) {
        expect(fades, findsNothing);
      } else {
        expect(tester.widget<FadeTransition>(fades).opacity.value,
            inExclusiveRange(0, 1));
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
