import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:flutter/material.dart';

abstract final class AppCategoryIconTheme {
  static const appearanceColors = [
    Color(0xFFBC2BC9),
    Color(0xFFE52D68),
    Color(0xFFFF3025),
    Color(0xFF10B981),
    Color(0xFF3864FF),
    Color(0xFF7533FF),
    Color(0xFFD9A000),
    Color(0xFFEF7D24),
    Color(0xFF607D8B),
  ];
  static Color selectionGap(BuildContext context) =>
      AppFinanceSurfaceTheme.background(context);
  static ButtonStyle appearanceEditButton(BuildContext context) =>
      IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          minimumSize: const Size.square(44),
          shape: const CircleBorder());
  static const double size = 24;
  static Color savedColor(BuildContext context, String? hex,
      {Color? fallback}) {
    final value = (hex ?? '')
        .trim()
        .replaceFirst(RegExp(r'^(#|0x)', caseSensitive: false), '');
    if (value.length != 6 && value.length != 8) {
      return fallback ?? Theme.of(context).colorScheme.onSurface;
    }
    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null || parsed < 0) {
      return fallback ?? Theme.of(context).colorScheme.onSurface;
    }
    return Color(value.length == 6 ? 0xFF000000 | parsed : parsed);
  }

  // Keep the chosen hue and saturation, changing tone only when necessary
  // for an outline to remain readable directly on the shared card surface.
  static Color color(BuildContext context, String? hex,
      {Color? background, Color? fallback}) {
    final saved = savedColor(context, hex, fallback: fallback);
    final card =
        background ?? Theme.of(context).colorScheme.surfaceContainerLowest;
    final visible = Color.alphaBlend(saved, card);
    if (_contrast(visible, card) >= 3) return saved;
    final hsl = HSLColor.fromColor(visible);
    final target = card.computeLuminance() > .179 ? 0.0 : 1.0;
    var low = 0.0;
    var high = 1.0;
    for (var step = 0; step < 12; step++) {
      final middle = (low + high) / 2;
      final candidate = hsl
          .withLightness(hsl.lightness + (target - hsl.lightness) * middle)
          .toColor();
      if (_contrast(candidate, card) >= 3) {
        high = middle;
      } else {
        low = middle;
      }
    }
    return hsl
        .withLightness(hsl.lightness + (target - hsl.lightness) * high)
        .toColor();
  }

  static double _contrast(Color first, Color second) {
    final a = first.computeLuminance();
    final b = second.computeLuminance();
    return a > b ? (a + .05) / (b + .05) : (b + .05) / (a + .05);
  }

  static TextStyle label(BuildContext context, {bool selected = false}) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyMedium!.copyWith(
      fontSize: AppTypography.body,
      color: selected
          ? theme.colorScheme.onSecondaryContainer
          : theme.colorScheme.onSurface,
    );
  }

  static TextStyle title(BuildContext context) =>
      label(context).copyWith(fontSize: AppTypography.title);
  static TextStyle search(BuildContext context) =>
      label(context).copyWith(fontSize: AppTypography.input);
}
