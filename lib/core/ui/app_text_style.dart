import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:flutter/material.dart';

/// Const-friendly semantic text styles. Colors inherit from the active theme.
/// Amounts opt into Inter through AppTextTheme.amount; normal text stays regular.
class AppTextStyle extends TextStyle {
  const AppTextStyle(
    AppTextRole role, {
    super.color,
    super.backgroundColor,
    super.height,
    super.letterSpacing,
    super.wordSpacing,
    super.decoration,
    super.decorationColor,
    super.decorationStyle,
    super.decorationThickness,
    super.fontStyle,
    super.textBaseline,
    super.overflow,
    super.shadows,
    super.fontFeatures,
    super.fontVariations,
    super.inherit,
    super.leadingDistribution,
  }) : super(
          fontFamily: AppTypography.regularFontFamily,
          fontWeight: FontWeight.normal,
          fontSize: role == AppTextRole.pageTitle
              ? AppTypography.headline
              : role == AppTextRole.sheetTitle
                  ? AppTypography.title
                  : role == AppTextRole.supporting
                      ? AppTypography.supporting
                      : role == AppTextRole.caption
                          ? AppTypography.caption
                          : role == AppTextRole.input
                              ? AppTypography.input
                              : role == AppTextRole.button
                                  ? AppTypography.button
                                  : role == AppTextRole.profile
                                      ? AppTypography.profile
                                      : role == AppTextRole.display
                                          ? AppTypography.display
                                          : role == AppTextRole.hero
                                              ? AppTypography.hero
                                              : role == AppTextRole.badge
                                                  ? AppTypography.badge
                                                  : AppTypography.body,
        );
}
