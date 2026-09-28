import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses the shared large action-button dimensions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OutlinedSquareButton(
            icon: Icons.menu_rounded,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(OutlinedSquareButton)),
      const Size.square(AppControlMetrics.iconButtonSize),
    );
    expect(
      tester.widget<Icon>(find.byIcon(Icons.menu_rounded)).size,
      AppControlMetrics.iconSize,
    );
  });
}
