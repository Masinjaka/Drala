import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_interaction_theme.dart';
import 'package:flutter/material.dart';

abstract final class AppEmptyStateTheme {
  static ButtonStyle action(BuildContext context) =>
      AppInteractionTheme.withoutPressFeedback(TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        textStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontSize: AppTypography.input),
      ));
  static TextStyle message(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: AppTypography.input,
          color: Theme.of(context).colorScheme.onSurface);
  static const illustrationWidth = 120.0;
  static const compactIllustrationWidth = 104.0;
  static TextStyle homeLabel(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: AppTypography.body,
          color: Theme.of(context).colorScheme.onSurfaceVariant);
  static TextStyle supportingMessage(BuildContext context) => message(context)
      .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

  static TextStyle inlineLink(BuildContext context) => TextStyle(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppTheme.positiveAmountDark
          : AppTheme.positiveAmountLight);
}
