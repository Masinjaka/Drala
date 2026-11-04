import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_category_theme.dart';
import 'package:budgets/core/ui/app_navigation_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets('shared selection uses the correct ${theme.brightness} surface',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          theme: theme,
          home: Builder(builder: (context) {
            final selection = AppNavigationTheme.selectedBackground(context);
            expect(
                selection,
                theme.brightness == Brightness.dark
                    ? theme.scaffoldBackgroundColor
                    : const Color(0xFF353333));
            expect(AppCategoryTheme.selectedBackground(context), selection);
            return const SizedBox();
          })));
    });
  }
}
