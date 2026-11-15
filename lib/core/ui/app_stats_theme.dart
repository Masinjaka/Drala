import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'app_header_theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/theme.dart';

abstract final class AppStatsTheme {
  static const netAmountSize = AppTypography.netAmount;
  static const netCurrencySize = AppTypography.input;
  static const axisGap = 12.0;
  static const flowIconSize = 28.0;
  static double metricHeight(BuildContext context) =>
      170 +
      (MediaQuery.textScalerOf(context).scale(12) / 12 - 1)
              .clamp(0, double.infinity) *
          44;
  static double spendingHeight(BuildContext context) =>
      265 +
      (MediaQuery.textScalerOf(context).scale(12) / 12 - 1)
              .clamp(0, double.infinity) *
          70;
  static double axisWidth(BuildContext context) =>
      35 * (MediaQuery.textScalerOf(context).scale(10) / 10).clamp(1, 2);
  static Color background(BuildContext context) =>
      AppHomeOverviewTheme.background(context);
  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLowest;
  static Color accent(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  static LinearGradient chartFill(BuildContext context) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          accent(context).withValues(
              alpha:
                  Theme.of(context).brightness == Brightness.dark ? .28 : .20),
          accent(context).withValues(alpha: 0)
        ],
      );
  static Color foreground(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
  static Color flowIconColor(BuildContext context, {required bool income}) =>
      income
          ? Theme.of(context).colorScheme.onSurface
          : AppFinanceSurfaceTheme.expenseAccent(context);
  static Color grid(BuildContext context) =>
      Theme.of(context).colorScheme.outline;
  static List<BoxShadow> shadows(BuildContext context) => [
        BoxShadow(
            color: Theme.of(context).shadowColor.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? .18
                    : .05),
            blurRadius: 8,
            offset: const Offset(0, 4))
      ];
  static TextStyle label(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: AppTypography.body,
          height: 16 / 12,
          color: foreground(context));
  static TextStyle caption(BuildContext context) => label(context).copyWith(
      fontSize: AppTypography.caption,
      height: 14 / 10,
      color: Theme.of(context)
          .colorScheme
          .onSurfaceVariant
          .withValues(alpha: .75));
  static TextStyle title(BuildContext context) => label(context).copyWith(
      shadows: AppHeaderTheme.titleShadows(context),
      fontSize: AppTypography.headline,
      height: 1.3);
  static TextStyle metricLabel(BuildContext context) =>
      caption(context).copyWith(fontSize: AppTypography.body);
  static TextStyle amount(BuildContext context, double size) =>
      AppTextTheme.amount(label(context).copyWith(
          fontSize: size,
          height: 1.3,
          color: AppHomeOverviewTheme.amountForeground(context),
          fontVariations: const [FontVariation('wght', 700)]));
  static TextStyle netAmount(BuildContext context) =>
      amount(context, netAmountSize).copyWith(
          fontWeight: FontWeight.w500,
          fontVariations: const [FontVariation('wght', 500)]);
  static TextStyle currency(BuildContext context, double size) =>
      label(context).copyWith(fontSize: size, height: 1.3);
  static TextStyle axis(BuildContext context) => caption(context).copyWith(
      fontSize: AppTypography.caption,
      height: 1.2,
      color: Theme.of(context)
          .colorScheme
          .onSurfaceVariant
          .withValues(alpha: .65));
  static TextStyle donutValue(BuildContext context) =>
      label(context).copyWith(fontSize: AppTypography.caption, height: 1.2);
  static TextStyle donutCaption(BuildContext context) =>
      caption(context).copyWith(fontSize: AppTypography.badge, height: 1.3);
  static TextStyle percentage(BuildContext context, Color background) {
    final luminance =
        Color.alphaBlend(background, surface(context)).computeLuminance();
    final darkContrast = (luminance + .05) /
        (AppTheme.interactiveTextColor.computeLuminance() + .05);
    final lightContrast =
        (AppTheme.textDark.computeLuminance() + .05) / (luminance + .05);
    return label(context).copyWith(
        fontSize: AppTypography.caption,
        height: 14 / 9,
        color: darkContrast >= lightContrast
            ? AppTheme.interactiveTextColor
            : AppTheme.textDark);
  }

  static Color categoryColor(BuildContext context, String? hex) {
    final value = (hex ?? '')
        .trim()
        .replaceFirst(RegExp(r'^(#|0x)', caseSensitive: false), '');
    if (value.length != 6 && value.length != 8) return accent(context);
    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null || parsed < 0) return accent(context);
    return Color(value.length == 6 ? 0xFF000000 | parsed : parsed);
  }

  static Color ringTrack(BuildContext context) => background(context);
}
