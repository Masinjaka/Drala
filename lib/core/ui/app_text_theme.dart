import 'package:budgets/core/ui/app_danger_theme.dart';
import 'app_header_theme.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_text_style.dart';

abstract final class AppTextTheme {
  static TextStyle onboardingWordmark(BuildContext context) =>
      AppTextStyle(AppTextRole.display,
          color: Theme.of(context).colorScheme.onPrimary);

  // Emoji is artwork, sized to its illustration rather than the text scale.
  static TextStyle onboardingEmoji(BuildContext context, double size) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: size * .45,
            height: 1,
          );

  static TextStyle amount(TextStyle base) => base.copyWith(
        fontFamily: AppTypography.amountFontFamily,
        fontWeight: FontWeight.bold,
        fontFamilyFallback: const [AppTypography.regularFontFamily],
      );

  static TextStyle authTitle(BuildContext context) => Theme.of(context)
      .textTheme
      .titleLarge!
      .copyWith(shadows: AppHeaderTheme.titleShadows(context));
  static TextStyle onboardingTitle(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!;
  static TextStyle setupTitle(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall!.copyWith(height: 1.25);
  static TextStyle setupBody(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(height: 16 / 12);
  static TextStyle setupLabel(BuildContext context) =>
      setupBody(context).copyWith(height: 1);
  static TextStyle setupSelectionBody(BuildContext context) =>
      setupBody(context);
  static TextStyle setupSection(BuildContext context) => setupBody(context);
  static TextStyle setupAction(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!;
  static TextStyle onboardingBody(BuildContext context) => setupBody(context);
  static TextStyle onboardingLabel(BuildContext context) => setupLabel(context);
  static TextStyle authBody(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
  static TextStyle authHint(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );
  static TextStyle authLabel(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
  static TextStyle legalLink(BuildContext context) =>
      authLabel(context).copyWith(decoration: TextDecoration.underline);
  static TextStyle envelopeAmount(BuildContext context) =>
      amount(Theme.of(context).textTheme.bodyMedium!);
  static TextStyle currencyLabel(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );
  static TextStyle envelopeWarning(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
            color: AppDangerTheme.criticalWarning(context),
          );
  static Color envelopeWarningBackground(BuildContext context) =>
      AppDangerTheme.criticalWarning(context).withValues(alpha: .18);
  static TextStyle monthCarousel(BuildContext context,
      {required bool selected}) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyLarge!.copyWith(
      color: selected
          ? theme.colorScheme.onSurface
          : theme.colorScheme.onSurfaceVariant.withValues(alpha: .68),
    );
  }

  static TextStyle drawerMenu(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
  static TextStyle notificationBadge(BuildContext context) =>
      AppTextStyle(AppTextRole.badge,
          color: AppDangerTheme.onCriticalWarning(context));

  static TextTheme create(Color foreground) => TextTheme(
        displayLarge: AppTextStyle(AppTextRole.hero, color: foreground),
        displayMedium: AppTextStyle(AppTextRole.hero, color: foreground),
        displaySmall: AppTextStyle(AppTextRole.hero, color: foreground),
        headlineLarge: AppTextStyle(AppTextRole.display, color: foreground),
        headlineMedium: AppTextStyle(AppTextRole.display, color: foreground),
        headlineSmall: AppTextStyle(AppTextRole.pageTitle, color: foreground),
        titleLarge: AppTextStyle(AppTextRole.pageTitle, color: foreground),
        titleMedium: AppTextStyle(AppTextRole.sheetTitle, color: foreground),
        titleSmall: AppTextStyle(AppTextRole.sectionTitle, color: foreground),
        bodyLarge: AppTextStyle(AppTextRole.input, color: foreground),
        bodyMedium: AppTextStyle(AppTextRole.body, color: foreground),
        bodySmall: AppTextStyle(AppTextRole.supporting, color: foreground),
        labelLarge: AppTextStyle(AppTextRole.button, color: foreground),
        labelMedium: AppTextStyle(AppTextRole.body, color: foreground),
        labelSmall: AppTextStyle(AppTextRole.caption, color: foreground),
      );
}
