import 'package:budgets/core/ui/app_danger_theme.dart';
import 'app_header_theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/app_interaction_theme.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:flutter/material.dart';

abstract final class AppEnvelopeTheme {
  static const radius = BorderRadius.all(Radius.circular(25));
  static BorderRadius cardRadius({required bool first, required bool last}) =>
      BorderRadius.vertical(
          top: Radius.circular(first ? 20 : 10),
          bottom: Radius.circular(last ? 24 : 10));
  static Color background(BuildContext context) =>
      AppHomeOverviewTheme.background(context);
  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLowest;
  static Color accent(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  static Color progressTrack(BuildContext context) => background(context);
  static Color progress(BuildContext context, {required bool exceeded}) =>
      exceeded ? AppDangerTheme.criticalWarning(context) : accent(context);
  static List<BoxShadow> shadows(BuildContext context) => [
        BoxShadow(
            color: Theme.of(context).shadowColor.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? .18
                    : .05),
            blurRadius: 8,
            offset: const Offset(0, 4))
      ];
  static TextStyle title(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          shadows: AppHeaderTheme.titleShadows(context),
          fontSize: AppTypography.headline,
          color: Theme.of(context).colorScheme.onSurface);
  static TextStyle name(BuildContext context) =>
      title(context).copyWith(fontSize: AppTypography.body, height: 16 / 12);
  static TextStyle label(BuildContext context) => name(context).copyWith(
      fontSize: AppTypography.supporting,
      height: 16 / 11,
      color: Theme.of(context).colorScheme.onSurfaceVariant);
  static TextStyle amount(BuildContext context) => name(context);
  static TextStyle percentage(BuildContext context) =>
      name(context).copyWith(fontSize: AppTypography.input, height: 16 / 14);
  static TextStyle year(BuildContext context) => percentage(context);
  static TextStyle month(BuildContext context, {required bool selected}) =>
      name(context).copyWith(
          fontSize: AppTypography.input,
          color: selected
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: .65));
  static ButtonStyle headerActionButton(BuildContext context) =>
      yearButton(context).copyWith(
        minimumSize: const WidgetStatePropertyAll(
          Size.square(AppHeaderMetrics.buttonSize),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      );

  static ButtonStyle yearButton(BuildContext context) =>
      AppInteractionTheme.withoutPressFeedback(TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: surface(context),
          minimumSize: const Size(90, AppHeaderMetrics.buttonSize),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: const StadiumBorder(),
          textStyle: year(context)));
}
