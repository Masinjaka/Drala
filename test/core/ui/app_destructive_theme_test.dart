import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets('destructive icons retain contrast in ${theme.brightness}',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          theme: theme,
          home: Builder(
            builder: (context) {
              final red = AppFinanceSurfaceTheme.destructive(context);
              final background = AppFinanceSurfaceTheme.field(context);
              final first = red.computeLuminance();
              final second = background.computeLuminance();
              final ratio = (first > second)
                  ? (first + .05) / (second + .05)
                  : (second + .05) / (first + .05);
              expect(ratio, greaterThanOrEqualTo(3));
              expect(red, isNot(theme.colorScheme.error));
              return const SizedBox();
            },
          )));
    });
  }
}
