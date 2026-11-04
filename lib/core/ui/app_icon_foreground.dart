import 'package:flutter/material.dart';

abstract final class AppIconForeground {
  static Color resolve(
    BuildContext context,
    Color? lightColor, {
    Color? background,
  }) {
    final theme = Theme.of(context);
    if (background == theme.colorScheme.error) {
      return theme.colorScheme.onError;
    }
    if (lightColor == theme.colorScheme.error) return theme.colorScheme.error;
    if (theme.brightness == Brightness.dark &&
        background == theme.colorScheme.primary) {
      return theme.colorScheme.onPrimary;
    }
    return theme.brightness == Brightness.dark
        ? theme.iconTheme.color!
        : lightColor ?? theme.iconTheme.color!;
  }
}
