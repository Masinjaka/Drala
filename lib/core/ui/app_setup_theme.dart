import 'package:flutter/material.dart';

/// Theme roles for the onboarding controls.
abstract final class AppSetupTheme {
  static Color categoryBadge(BuildContext context, String key) {
    final color = switch (key) {
      'shopping' => const Color(0xFFEEC77F),
      'transport' => const Color(0xFFD5C9FF),
      'health' => const Color(0xFF2F80ED),
      'utilities' => const Color(0xFF88E852),
      'food' => const Color(0xFFEE7EB5),
      'entertainment' => const Color(0xFFFFC5C5),
      'salary' => const Color(0xFFE5B997),
      'freelance' => const Color(0xFFFFCACD),
      _ => Theme.of(context).colorScheme.secondary,
    };
    return Theme.of(context).brightness == Brightness.dark
        ? color.withValues(alpha: .7)
        : color;
  }

  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).colorScheme.surfaceContainerLowest
          : Theme.of(context).scaffoldBackgroundColor;

  static Color choiceBackground(BuildContext context,
          {required bool selected}) =>
      selected
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.surfaceContainer;

  static Color choiceForeground(BuildContext context,
          {required bool selected}) =>
      selected
          ? Theme.of(context).scaffoldBackgroundColor
          : Theme.of(context).colorScheme.onSurface;
}
