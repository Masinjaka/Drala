import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'app_header_theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:flutter/material.dart';

abstract final class AppActivitiesTheme {
  static const calendarSelectionDuration = Duration(milliseconds: 260);
  static const calendarPinnedBottomGap = 12.0;
  static Color background(BuildContext context) =>
      AppHomeOverviewTheme.background(context);
  static Color card(BuildContext context) =>
      AppHomeOverviewTheme.surface(context);
  static Color selectedDay(BuildContext context) => background(context);
  static Color composer(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF4F4F4)
          : Theme.of(context).colorScheme.surfaceContainer;
  static TextStyle title(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          shadows: AppHeaderTheme.titleShadows(context),
          fontSize: AppTypography.headline);
  static TextStyle label(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: AppTypography.body,
          color: Theme.of(context).colorScheme.onSurface);
  static TextStyle caption(BuildContext context) => label(context).copyWith(
      fontSize: AppTypography.caption,
      color: Theme.of(context).colorScheme.onSurfaceVariant);
  static TextStyle weekday(BuildContext context, {required bool enabled}) =>
      caption(context).copyWith(
          height: 1.2,
          color: enabled
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).disabledColor);
  static TextStyle day(BuildContext context, {required bool enabled}) =>
      weekday(context, enabled: enabled)
          .copyWith(fontSize: AppTypography.input);
  static TextStyle composerText(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: AppTypography.input, height: 1.35);
  static TextStyle composerHint(BuildContext context) =>
      composerText(context).copyWith(
          fontSize: AppTypography.body,
          fontWeight: FontWeight.w300,
          color: Theme.of(context)
              .colorScheme
              .onSurfaceVariant
              .withValues(alpha: .78));
  static TextStyle creditNotice(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Theme.of(context).textTheme.bodySmall!.color);
  static TextStyle net(BuildContext context, {required bool positive}) =>
      label(context).copyWith(
          color: positive
              ? Theme.of(context).colorScheme.primary
              : AppFinanceSurfaceTheme.expenseAccent(context));
}
