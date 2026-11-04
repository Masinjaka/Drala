import 'app_category_icon_theme.dart';
import 'package:flutter/material.dart';
import 'app_home_overview_theme.dart';
import 'app_navigation_theme.dart';
import 'app_envelope_theme.dart';

abstract final class AppCategoryTheme {
  static const cardRadius =
      BorderRadius.all(AppHomeOverviewTheme.transactionOuterRadius);
  static Color background(BuildContext context) =>
      AppHomeOverviewTheme.background(context);
  static Color surface(BuildContext context) =>
      AppHomeOverviewTheme.surface(context);
  static Color accent(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  static Color savedIconColor(BuildContext context, String? hex) =>
      AppCategoryIconTheme.savedColor(context, hex, fallback: accent(context));
  static Color icon(BuildContext context, String? hex) =>
      AppCategoryIconTheme.color(context, hex,
          background: surface(context), fallback: accent(context));

  static Color selectedBackground(BuildContext context) =>
      AppNavigationTheme.selectedBackground(context);
  static TextStyle name(BuildContext context) =>
      AppHomeOverviewTheme.label(context);
  static TextStyle tab(BuildContext context, {required bool selected}) =>
      AppEnvelopeTheme.month(context, selected: selected).copyWith(
        color: selected
            ? AppNavigationTheme.foreground(context, selected: true)
            : Theme.of(context).colorScheme.onSurfaceVariant,
      );
}
