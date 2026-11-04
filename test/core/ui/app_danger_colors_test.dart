import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/core/ui/app_toast_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'danger icons preserve semantic contrast in ${theme.brightness}',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          theme: theme,
          home: Builder(builder: (context) {
            final colors = Theme.of(context).colorScheme;
            expect(
                AppIconForeground.resolve(context, colors.error), colors.error);
            expect(
                AppIconForeground.resolve(context, colors.onError,
                    background: colors.error),
                colors.onError);
            return const SizedBox();
          })));
    });
    test('danger roles are legible in ${theme.brightness}', () {
      final colors = theme.colorScheme;
      for (final surface in [
        colors.surface,
        colors.surfaceContainerLowest,
        theme.scaffoldBackgroundColor
      ]) {
        expect(_contrast(colors.error, surface), greaterThanOrEqualTo(4.5));
      }
      expect(
          _contrast(colors.onError, colors.error), greaterThanOrEqualTo(4.5));
      expect(_contrast(colors.onErrorContainer, colors.errorContainer),
          greaterThanOrEqualTo(4.5));
      final toast = theme.extension<AppToastTheme>()!;
      expect(_contrast(toast.errorForeground, toast.error),
          greaterThanOrEqualTo(4.5));
      expect(_contrast(toast.error, toast.background), greaterThanOrEqualTo(3));
    });
  }
}

double _contrast(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return a > b ? (a + .05) / (b + .05) : (b + .05) / (a + .05);
}
