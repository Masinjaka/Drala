import 'package:flutter/material.dart';

/// Semantic error/danger pairs, including contrast-safe inverse surfaces.
abstract final class AppDangerTheme {
  static const fill = Color(0xFFD22D39);
  static const onFill = Colors.white;
  static const lightError = fill;
  static const lightForeground = onFill;
  static const lightContainer = Color(0xFFF9E2E3);
  static const lightContainerForeground = Color(0xFF481217);

  // A 45% white tint of the danger fill keeps small text legible on dark cards.
  static const darkError = Color(0xFFE68C92);
  static const darkForeground = lightContainerForeground;
  static const darkContainer = fill;
  static const darkContainerForeground = onFill;

  static const expenseSeries = Color(0xFFC96565);
  static const legacyRedLight = Color(0xFFB3261E);
  static const legacyRedDark = Color(0xFFF2B8B5);

  static Color criticalWarning(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? legacyRedDark
          : legacyRedLight;

  static Color onCriticalWarning(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF601410)
          : Colors.white;

  static const _warningLight = Color(0xFF805600);
  static const _warningDark = Color(0xFFF2CC8F);

  static Color warning(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? _warningDark
          : _warningLight;
}
