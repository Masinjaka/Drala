import 'package:budgets/core/ui/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppNavigationTheme {
  static Color background(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainer;

  static Color barBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? const Color(0xFF211F1F)
          : Theme.of(context).colorScheme.surfaceContainerLowest;
  static Color selectedBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? const Color(0xFF353333)
          : Theme.of(context).scaffoldBackgroundColor;

  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF4F4F4)
          : Theme.of(context).colorScheme.outlineVariant;

  static Color foreground(BuildContext context, {required bool selected}) =>
      selected ? Colors.white : const Color(0xFF9E9E9E);
  static Color icon(BuildContext context, {required bool selected}) =>
      foreground(context, selected: selected);

  static TextStyle label(BuildContext context,
          {required int index, required bool selected}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: foreground(context, selected: selected),
            fontSize: AppTypography.supporting,
            height: 1.2,
          );
}
