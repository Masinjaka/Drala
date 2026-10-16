import 'package:flutter/material.dart';

abstract final class AppNavigationTheme {
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Theme.of(context).scaffoldBackgroundColor;

  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF4F4F4)
          : Theme.of(context).colorScheme.outlineVariant;

  static Color foreground(BuildContext context, {required bool selected}) =>
      Theme.of(context).brightness == Brightness.light
          ? selected
              ? const Color(0xFF343434)
              : const Color(0xFF6B6B6B)
          : selected
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.onSurfaceVariant;

  static Color icon(BuildContext context, {required bool selected}) =>
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).iconTheme.color!
          : selected
              ? foreground(context, selected: selected)
              : const Color(0xFF9E9E9E);

  static TextStyle label(BuildContext context,
          {required int index, required bool selected}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: foreground(context, selected: selected),
            fontSize: index < 2 ? 11 : 10,
            height: 1.2,
          );
}
