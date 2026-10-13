import 'package:budgets/core/ui/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppSettingsTheme {
  static const _categoryLight = Color(0xFFF0F9AF);
  static const _walletLight = Color(0xFFFAAA6C);
  static const _logoutLight = Color(0xFFF25959);
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

  static Color logout(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _logoutLight
          : Theme.of(context).colorScheme.error;

  static TextStyle pageTitle(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
            fontFamily: AppTypography.amountFontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          );

  static TextStyle profileName(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );

  static TextStyle menuLabel(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          );

  static TextStyle summaryTitle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );

  static TextStyle summaryCount(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
            fontFamily: AppTypography.amountFontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          );

  static TextStyle logoutLabel(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: logout(context),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          );

  static TextStyle badge(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall!.copyWith(
            color: Theme.of(context).colorScheme.onError,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          );
}
