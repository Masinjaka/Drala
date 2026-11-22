import 'package:budgets/core/ui/app_toast_theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:flutter/material.dart';

/// Colors and text for the app-wide "you are offline" banner.
abstract final class AppOfflineBannerTheme {
  static const iconSize = 20.0;
  static const minHeight = 44.0;

  static bool _light(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  /// Same warm yellow as the info toast, so warnings read consistently.
  static Color background(BuildContext context) =>
      _light(context) ? AppToastTheme.light.info : AppToastTheme.dark.info;

  static Color foreground(BuildContext context) =>
      AppToastTheme.light.iconForeground;

  static TextStyle message(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: AppTypography.body,
            fontWeight: FontWeight.normal,
            color: foreground(context),
          );
}
