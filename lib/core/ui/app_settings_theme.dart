import 'app_icon_foreground.dart';
import 'app_header_theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:flutter/material.dart';

abstract final class AppSettingsTheme {
  static Color signInBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
  static Color signInForeground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white;
  static Color background(BuildContext context) =>
      AppHomeOverviewTheme.background(context);
  static Color summaryIcon(BuildContext context) =>
      AppIconForeground.monochrome(context);
  static Color surface(BuildContext context) =>
      AppHomeOverviewTheme.surface(context);
  static const outerRadius = AppHomeOverviewTheme.transactionOuterRadius;
  static const innerRadius = AppHomeOverviewTheme.transactionInnerRadius;
  static const _categoryLight = Color(0xFFF0F9AF);
  static const _walletLight = Color(0xFFFAAA6C);
  static const _iconSurfaceLight = Color(0xFFF4F4F4);

  static Color categoryCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _categoryLight
          : const Color(0xFF59622B);

  static Color walletCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _walletLight
          : const Color(0xFF754A2B);

  static Color iconSurface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _iconSurfaceLight
          : Theme.of(context).colorScheme.surfaceContainer;

  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _iconSurfaceLight
          : Theme.of(context).colorScheme.surfaceContainer;

  static Color foreground(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color iconForeground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).iconTheme.color!
          : foreground(context);

  static Color syncFailureIcon(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  static TextStyle pageTitle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          shadows: AppHeaderTheme.titleShadows(context),
          fontSize: AppTypography.headline);

  static TextStyle profileName(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: AppTypography.profile,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );

  static TextStyle supportingLabel(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );

  static TextStyle menuLabel(BuildContext context,
          {bool destructive = false}) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: destructive ? Theme.of(context).colorScheme.error : null,
            fontSize: AppTypography.body,
            fontWeight: FontWeight.normal,
          );

  static TextStyle summaryTitle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: AppTypography.body,
            fontWeight: FontWeight.normal,
          );

  static TextStyle summaryCount(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
            fontFamily: AppTypography.amountFontFamily,
            fontSize: AppTypography.headline,
            fontWeight: FontWeight.w600,
          );

  static TextStyle badge(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onError,
            fontSize: AppTypography.caption,
            fontWeight: FontWeight.w600,
          );
}
