import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'equivalent roles agree across ${theme.brightness.name} screens',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Builder(builder: (context) {
          final labels = [
            AppHomeOverviewTheme.label(context),
            AppActivitiesTheme.label(context),
            AppEnvelopeTheme.name(context),
            AppStatsTheme.label(context),
            AppSettingsTheme.menuLabel(context),
          ];
          for (final style in labels) {
            expect(style.fontSize, AppTypography.body);
            expect(style.fontWeight, FontWeight.normal);
            expect(style.fontFamily, AppTypography.regularFontFamily);
          }
          for (final style in [
            AppHomeOverviewTheme.welcome(context),
            AppActivitiesTheme.title(context),
            AppEnvelopeTheme.title(context),
            AppStatsTheme.title(context),
            AppSettingsTheme.pageTitle(context),
          ]) {
            expect(style.fontSize, AppTypography.headline);
            expect(style.fontWeight, FontWeight.normal);
          }
          final input = Theme.of(context).textTheme.bodyLarge!;
          final button = Theme.of(context)
              .filledButtonTheme
              .style!
              .textStyle!
              .resolve({})!;
          expect(input.fontSize, AppTypography.input);
          expect(button.fontSize, AppTypography.button);
          expect(button.fontWeight, FontWeight.normal);
          expect(AppSettingsTheme.supportingLabel(context).fontSize,
              AppTypography.supporting);
          final amount = AppTextTheme.amount(labels.first);
          expect(amount.fontFamily, AppTypography.amountFontFamily);
          expect(amount.fontSize, labels.first.fontSize);
          return const SizedBox();
        }),
      ));
    });
  }
}
