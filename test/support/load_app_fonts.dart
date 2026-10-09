import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:flutter/services.dart';

Future<void> loadAppFonts() async {
  await (FontLoader(AppTheme.fontFamily)
        ..addFont(rootBundle.load('assets/fonts/Alexandria-Regular.ttf'))
        ..addFont(rootBundle.load('assets/fonts/Alexandria-Medium.ttf'))
        ..addFont(rootBundle.load('assets/fonts/Alexandria-SemiBold.ttf'))
        ..addFont(rootBundle.load('assets/fonts/Alexandria-Bold.ttf'))
        ..addFont(rootBundle.load('assets/fonts/Alexandria-ExtraBold.ttf')))
      .load();
  await (FontLoader(AppTypography.amountFontFamily)
        ..addFont(rootBundle.load('assets/fonts/Inter.ttf')))
      .load();
}
