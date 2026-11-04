import 'package:budgets/core/theme.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('long amount ellipsizes before currency and stays fully editable',
      (tester) async {
    final controller = TextEditingController(text: '123,456,789,123,456');
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
          body: Center(
              child: SizedBox(
        width: 260,
        child:
            TransactionAmountField(controller: controller, currencyCode: 'MGA'),
      ))),
    ));
    final label = find.byKey(const Key('amount-overflow-label'));
    expect(tester.widget<Text>(label).overflow, TextOverflow.ellipsis);
    expect(tester.getRect(label).right,
        lessThanOrEqualTo(tester.getRect(find.text('MGA')).left));
    await tester.tap(find.byKey(const Key('transaction-amount')));
    await tester.pump();
    expect(label, findsNothing);
    expect(controller.text, '123,456,789,123,456');
    await tester.enterText(find.byKey(const Key('transaction-amount')), '1234');
    FocusManager.instance.primaryFocus!.unfocus();
    await tester.pump();
    expect(controller.text, '1,234');
    expect(label, findsNothing);
    expect(tester.takeException(), isNull);
  });
}
