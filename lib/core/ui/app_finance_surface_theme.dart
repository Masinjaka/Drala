import 'package:flutter/material.dart';
import 'app_home_overview_theme.dart';
import 'app_text_theme.dart';
import 'app_typography.dart';

/// Surfaces and type shared by the supplied wallet and entry references.
abstract final class AppFinanceSurfaceTheme {
  static Color destructive(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xffed969b)
          : const Color(0xffa84e56);
  static ButtonStyle headerButton(BuildContext context) => IconButton.styleFrom(
      backgroundColor: field(context),
      disabledBackgroundColor: field(context),
      minimumSize: const Size(44, 44));
  static const selectionHeight = 44.0;
  static const selectionPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 10);
  static const cardRadius = BorderRadius.all(Radius.circular(24));
  static const sheetRadius = BorderRadius.vertical(top: Radius.circular(40));
  static const fieldRadius = BorderRadius.all(Radius.circular(28));
  static Color background(BuildContext context) =>
      AppHomeOverviewTheme.background(context);
  static Color field(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLowest;
  static Color action(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
  static Color onAction(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLowest;
  static Color border(BuildContext context) =>
      Theme.of(context).colorScheme.outline.withValues(alpha: .35);
  static TextStyle label(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
  static TextStyle title(BuildContext context) =>
      label(context).copyWith(fontSize: AppTypography.title);
  static TextStyle value(BuildContext context) => AppTextTheme.amount(
      label(context).copyWith(fontSize: AppTypography.headline));
  static TextStyle amount(BuildContext context) => AppTextTheme.amount(
      label(context).copyWith(fontSize: AppTypography.hero));
  static InputDecoration input(BuildContext context,
          {String? hint, Widget? prefix}) =>
      InputDecoration(
        hintText: hint,
        prefixIcon: prefix,
        filled: true,
        fillColor: field(context),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: fieldRadius,
            borderSide: BorderSide(color: border(context))),
        enabledBorder: OutlineInputBorder(
            borderRadius: fieldRadius,
            borderSide: BorderSide(color: border(context))),
        focusedBorder: OutlineInputBorder(
            borderRadius: fieldRadius,
            borderSide: BorderSide(color: action(context), width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: fieldRadius,
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: fieldRadius,
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
        errorMaxLines: 3,
      );
}
