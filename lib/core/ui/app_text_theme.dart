import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_typography.dart';

abstract final class AppTextTheme {
  static TextStyle onboardingWordmark(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onPrimary,
          );

  static TextStyle onboardingEmoji(BuildContext context, double size) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: size * .45,
            height: 1,
          );

  static TextStyle amount(TextStyle base) => base.copyWith(
        fontFamily: AppTypography.amountFontFamily,
        fontFamilyFallback: const [AppTypography.regularFontFamily],
      );

  static TextStyle authTitle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: AppTypography.display,
            fontWeight: FontWeight.w700,
          );
  static TextStyle onboardingTitle(BuildContext context) => authTitle(context);
  static TextStyle onboardingBody(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 12,
            height: 16 / 12,
          );
  static TextStyle onboardingLabel(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 13,
            height: 1,
          );
  static TextStyle authBody(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: AppTypography.supporting);
  static TextStyle authHint(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: AppTypography.caption,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );
  static TextStyle authLabel(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: AppTypography.supporting);
  static TextStyle legalLink(BuildContext context) =>
      authLabel(context).copyWith(decoration: TextDecoration.underline);

  static TextStyle envelopeAmount(BuildContext context) => amount(
        Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
      );

  static TextStyle currencyLabel(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );

  static TextStyle envelopeWarning(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 9,
            color: Theme.of(context).colorScheme.error,
          );

  static Color envelopeWarningBackground(BuildContext context) =>
      Theme.of(context).colorScheme.error.withValues(alpha: .18);

  static TextStyle monthCarousel(BuildContext context,
      {required bool selected}) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyMedium!.copyWith(
      color: selected
          ? theme.colorScheme.onSurface
          : theme.colorScheme.onSurfaceVariant.withValues(alpha: .68),
      fontSize: selected ? AppTypography.body : AppTypography.caption,
      fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
    );
  }

  static TextStyle drawerMenu(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.normal,
          );

  static TextTheme create(Color foreground) => TextTheme(
        headlineMedium: TextStyle(
            color: foreground,
            fontSize: 29,
            fontWeight: FontWeight.w500,
            height: 1),
        displaySmall: TextStyle(
          color: foreground,
          fontSize: 36,
          fontWeight: FontWeight.w600,
          height: 38 / 36,
        ),
        bodyLarge: TextStyle(
          color: foreground,
          fontSize: AppTypography.body,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: foreground,
          fontSize: AppTypography.body,
          fontWeight: FontWeight.normal,
        ),
        titleLarge: TextStyle(
          color: foreground,
          fontSize: AppTypography.headline,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: foreground,
          fontSize: AppTypography.title,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: foreground,
          fontSize: AppTypography.body,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          color: foreground,
          fontSize: AppTypography.supporting,
          fontWeight: FontWeight.w500,
        ),
        labelLarge: TextStyle(
          fontSize: AppTypography.body,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          fontSize: AppTypography.caption,
          fontWeight: FontWeight.w300,
        ),
      );
}
