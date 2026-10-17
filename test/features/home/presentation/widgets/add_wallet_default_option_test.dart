import 'package:budgets/features/home/presentation/widgets/add_wallet_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('new wallet can be selected as default in the form',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              final input = await AddWalletSheet.show(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${input?.setAsDefault}')),
                );
              }
            },
            child: const Text('Open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Savings');
    await tester.tap(find.byKey(const Key('wallet-default-option')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('confirm-add-wallet')));
    await tester.pumpAndSettle();
    expect(find.text('true'), findsOneWidget);
  });
}
