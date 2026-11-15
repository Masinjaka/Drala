import 'package:budgets/core/ui/app_danger_theme.dart';
import 'package:flutter/material.dart';

abstract final class AppIconForeground {
  static Color monochrome(BuildContext context) =>
      Theme.of(context).iconTheme.color!;

  static Color resolve(
    BuildContext context,
    Color? lightColor, {
    Color? background,
  }) {
    final theme = Theme.of(context);
    if (background == AppDangerTheme.fill) return AppDangerTheme.onFill;
    if (background == theme.colorScheme.error) {
      return theme.colorScheme.onError;
    }
    if (lightColor == theme.colorScheme.error) return theme.colorScheme.error;
    if (theme.brightness == Brightness.dark &&
        background == theme.colorScheme.primary) {
      return theme.colorScheme.onPrimary;
    }
    if (lightColor == theme.colorScheme.primary) return monochrome(context);
    return theme.brightness == Brightness.dark
        ? theme.iconTheme.color!
        : lightColor ?? theme.iconTheme.color!;
  }
}
