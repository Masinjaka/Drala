import 'package:budgets/features/settings/presentation/widgets/currency_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses transaction field shape and clears the search',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CurrencySearchField(controller: controller, hint: 'Search'),
      ),
    ));

    final field = tester.widget<TextField>(find.byType(TextField));
    final border = field.decoration!.border! as OutlineInputBorder;
    expect(border.borderRadius, BorderRadius.circular(6));

    await tester.enterText(find.byType(TextField), 'MGA');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.close_rounded));
    expect(controller.text, isEmpty);
  });
}
