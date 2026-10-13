import 'package:budgets/features/transactions/presentation/widgets/transaction_edit_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('transaction forms do not respond to vertical drags',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 300,
            child: TransactionEditScrollView(
              child: SizedBox(height: 600),
            ),
          ),
        ),
      ),
    );

    final scrollable = find.byType(CustomScrollView);
    final position = tester.state<ScrollableState>(
      find.descendant(
        of: scrollable,
        matching: find.byType(Scrollable),
      ),
    );

    expect(position.position.pixels, 0);
    await tester.drag(scrollable, const Offset(0, -120));
    await tester.pumpAndSettle();
    expect(position.position.pixels, 0);
  });
}
