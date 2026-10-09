import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app themes keep Alexandria for general numbers', () {
    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      final style = theme.textTheme.bodyMedium!;

      expect(style.fontFamily, AppTheme.fontFamily);
      expect(style.fontFamilyFallback, isNot(contains('Inter')));
    }
  });

  test('amount style uses Inter with Alexandria fallback', () {
    final style = AppTextTheme.amount(const TextStyle(fontSize: 18));

    expect(style.fontFamily, AppTypography.amountFontFamily);
    expect(
      style.fontFamilyFallback,
      contains(AppTypography.regularFontFamily),
    );
  });

  testWidgets('Inter is bundled', (tester) async {
    final font = await rootBundle.load(
      'assets/fonts/Inter.ttf',
    );

    expect(font.lengthInBytes, greaterThan(0));
  });
}
