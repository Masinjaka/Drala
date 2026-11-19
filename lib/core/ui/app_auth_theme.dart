import 'package:flutter/material.dart';
import 'app_text_theme.dart';
import 'app_typography.dart';

abstract final class AppAuthTheme {
  static const otpAspectRatio = 5 / 6;
  static const otpGap = 8.0;
  static const otpBorderRadius = BorderRadius.all(Radius.circular(12));

  static TextStyle otpDigit(BuildContext context) =>
      AppTextTheme.authBody(context).copyWith(fontSize: AppTypography.title);
}
