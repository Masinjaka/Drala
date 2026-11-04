import 'package:flutter/material.dart';

/// Semantic error/danger pairs, including contrast-safe inverse surfaces.
abstract final class AppDangerTheme {
  static const lightError = Color(0xFFB3261E);
  static const lightForeground = Colors.white;
  static const lightContainer = Color(0xFFF9DEDC);
  static const lightContainerForeground = Color(0xFF410E0B);
  static const darkError = Color(0xFFF2B8B5);
  static const darkForeground = Color(0xFF601410);
  static const darkContainer = Color(0xFF8C1D18);
  static const darkContainerForeground = Color(0xFFF9DEDC);

  // A stable data-series color must work on both chart backgrounds.
  static const expenseSeries = Color(0xFFC96565);
  static const _warningLight = Color(0xFF805600);
  static const _warningDark = Color(0xFFF2CC8F);

  static Color warning(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? _warningDark
          : _warningLight;
}
