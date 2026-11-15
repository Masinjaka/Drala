import 'package:budgets/core/theme.dart';
import 'package:budgets/features/transactions/presentation/widgets/reference_transaction_surface.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('picker rises over the fixed form and back preserves its input',
      (tester) async {
    final pages = PageController();
    final text = TextEditingController(text: 'Keep this draft');
    addTearDown(pages.dispose);
    addTearDown(text.dispose);
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                    onPressed: () => showTransactionFormSheet<void>(context,
                        builder: (_) => ReferenceTransactionSurface(
                                controller: pages,
                                pages: [
                                  Column(children: [
                                    TextField(controller: text),
                                    TextButton(
                                        onPressed: () => pages.animateToPage(1,
                                            duration: const Duration(
                                                milliseconds: 420),
                                            curve: Curves.linear),
                                        child: const Text('Pick'))
                                  ]),
                                  const ColoredBox(
                                      key: Key('picker-panel'),
                                      color: Colors.white,
                                      child: Center(child: Text('Choices'))),
                                ])),
                    child: const Text('Open'))))));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final formTop = tester.getTopLeft(find.byType(TextField));
    await tester.tap(find.text('Pick'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final movingTop = tester.getTopLeft(find.byKey(const Key('picker-panel')));
    expect(tester.getTopLeft(find.byType(TextField)), formTop);
    await tester.pumpAndSettle();
    final finalTop = tester.getTopLeft(find.byKey(const Key('picker-panel')));
    expect(movingTop.dx, finalTop.dx);
    expect(movingTop.dy, greaterThan(finalTop.dy));
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('picker-panel')), findsNothing);
    expect(find.text('Keep this draft'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
