import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';

abstract final class AppHomeOverviewTheme {
  static const transactionOuterRadius = Radius.circular(24);
  static const transactionInnerRadius = Radius.circular(10);

  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF4F4F4)
          : Theme.of(context).scaffoldBackgroundColor;
  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLowest;
  static Color iconBackground(BuildContext context) => background(context);
  static Color accent(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  static TextStyle welcome(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: AppTypography.headline);
  static TextStyle date(BuildContext context) => label(context).copyWith(
      fontSize: AppTypography.input,
      color: Theme.of(context).colorScheme.onSurfaceVariant);
  static TextStyle section(BuildContext context) => label(context);
  static TextStyle label(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: AppTypography.body);
  static TextStyle caption(BuildContext context) => label(context).copyWith(
      fontSize: AppTypography.caption,
      color: Theme.of(context).colorScheme.onSurfaceVariant);
  static Color amountForeground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? Colors.black
          : Theme.of(context).colorScheme.onSurface;
  static TextStyle balance(BuildContext context) =>
      AppTextTheme.amount(label(context).copyWith(
          fontSize: AppTypography.balance,
          color: amountForeground(context),
          fontVariations: const [FontVariation('wght', 700)]));
  static TextStyle amount(BuildContext context) => label(context);
  static TextStyle envelopeAmount(BuildContext context) =>
      AppTextTheme.amount(label(context).copyWith(
          fontSize: AppTypography.headline,
          fontVariations: const [FontVariation('wght', 700)]));
  static TextStyle transactionAmount(BuildContext context,
          {required bool income}) =>
      label(context).copyWith(
          color: income
              ? accent(context)
              : Theme.of(context).colorScheme.onSurface);
}
