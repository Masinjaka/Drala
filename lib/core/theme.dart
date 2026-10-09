import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/app_button_theme.dart';
import 'package:budgets/core/ui/app_icon_button_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static Color foregroundFor(Color background) =>
      ThemeData.estimateBrightnessForColor(background) == Brightness.dark
          ? textDark
          : interactiveTextColor;

  static Color setupSelectionColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? positiveAmountDark
          : positiveAmountLight;

  static Color onboardingChoiceColor(BuildContext context,
          {required bool selected}) =>
      selected
          ? Theme.of(context).brightness == Brightness.light
              ? homeBanner
              : raisedSurfaceLight
          : Theme.of(context).colorScheme.surfaceContainer;

  static Color onboardingChoiceForeground(BuildContext context,
          {required bool selected}) =>
      selected
          ? Theme.of(context).colorScheme.onInverseSurface
          : Theme.of(context).colorScheme.onSurface;

  static const String fontFamily = 'Alexandria';

  static const Color backgroundDark = Color(0xFF202123);
  static const Color secondaryDark = Color(0xFF2E3033);
  static const Color borderColorDark = Color(0xFF56595D);
  static const Color primaryGreen = Color(0xFF10B981);
  static const Color onboardingBlue = Color(0xFFBDE5FB);
  static const Color onboardingYellow = Color(0xFFF3FAC7);
  static const Color onboardingPink = Color(0xFFFBC8C7);
  static const Color onboardingLavender = Color(0xFFD7DAFF);
  static const Color onboardingPaleBlue = Color(0xFFE7F5FC);
  static const Color onboardingPalePink = Color(0xFFFCEAEA);
  static const Color homeBanner = Color(0xFF343434);
  static const Color homeBannerText = Color(0xFFF4F4F4);
  static const Color secondaryGreen = Color(0xff4C8352);
  static const Color dangerColor = Color(0xFFE57373);
  static const Color errorLight = Color(0xFFB42318);
  static const Color errorDark = Color(0xFFFDA4A4);
  static const Color positiveAmountLight = Color(0xFF006D4E);
  static const Color positiveAmountDark = Color(0xFF54DEAC);
  static const Color neutralSurface = Color(0xFFF3F3F3);
  static const Color textDark = Color(0xFFF5F5F5);
  static const Color mutedTextDark = Color(0xFFD0D0D0);
  static const Color raisedSurfaceDark = Color(0xFF3B3D40);
  static const Color skeletonBaseDark = Color(0xFF585B5F);
  static const Color skeletonHighlightDark = Color(0xFF8A8E93);
  static const Color skeletonBaseLight = Color(0xFFD9DEE3);
  static const Color skeletonHighlightLight = Color(0xFFEFF2F5);

  static const Color backgroundLight = Color(0xFFFEFEFE);
  static const Color secondaryLight = neutralSurface;
  static const Color raisedSurfaceLight = Colors.white;
  static const Color textLight = Color(0xFF333333);
  static const Color mutedTextLight = Color(0xFF606060);
  static const Color borderColorLight = Color(0xFFD8D8D8);
  static const Color incomeBadgeLight = Color(0xFFB9E5C7);
  static const Color expenseBadgeLight = Color(0xFFF3C1C1);
  static const Color transferBadgeLight = Color(0xFFB9D5F5);
  static const Color incomeBadgeDark = Color(0xFF244C3F);
  static const Color expenseBadgeDark = Color(0xFF533336);
  static const Color transferBadgeDark = Color(0xFF29405B);
  static const Color interactiveTextColor = Colors.black;
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    cardColor: secondaryLight,
    primaryColor: primaryGreen,
    fontFamily: fontFamily,
    iconTheme: const IconThemeData(color: textLight),
    textTheme: AppTextTheme.create(textLight),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight,
      elevation: 0,
      iconTheme: IconThemeData(color: textLight),
    ),
    dialogTheme: const DialogThemeData(backgroundColor: backgroundLight),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: backgroundLight,
    ),
    tabBarTheme: const TabBarThemeData(
      indicatorColor: backgroundDark,
      labelColor: backgroundLight,
      unselectedLabelColor: textLight,
    ),
    elevatedButtonTheme: AppButtonTheme.elevated(Brightness.light),
    textButtonTheme: AppButtonTheme.text(Brightness.light),
    outlinedButtonTheme: AppButtonTheme.outlined(Brightness.light),
    filledButtonTheme: AppButtonTheme.filled(Brightness.light),
    iconButtonTheme: AppIconButtonTheme.data,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      onPrimary: interactiveTextColor,
      secondary: secondaryGreen,
      error: errorLight,
      onError: Colors.white,
      surface: secondaryLight,
      surfaceDim: backgroundLight,
      surfaceContainer: secondaryLight,
      surfaceContainerLowest: raisedSurfaceLight,
      surfaceBright: skeletonBaseLight,
      surfaceContainerHigh: skeletonHighlightLight,
      onSurface: textLight,
      onSurfaceVariant: mutedTextLight,
      outline: borderColorLight,
      inverseSurface: Colors.black,
      onInverseSurface: raisedSurfaceLight,
      tertiary: borderColorDark,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    cardColor: secondaryDark,
    shadowColor: const Color(0xFF141619),
    primaryColor: primaryGreen,
    fontFamily: fontFamily,
    iconTheme: const IconThemeData(color: textDark),
    textTheme: AppTextTheme.create(textDark),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      elevation: 0,
      iconTheme: IconThemeData(color: textDark),
    ),
    dialogTheme: const DialogThemeData(backgroundColor: secondaryDark),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: secondaryDark,
    ),
    tabBarTheme: const TabBarThemeData(
      indicatorColor: backgroundLight,
      labelColor: backgroundDark,
      unselectedLabelColor: textDark,
    ),
    elevatedButtonTheme: AppButtonTheme.elevated(Brightness.dark),
    textButtonTheme: AppButtonTheme.text(Brightness.dark),
    outlinedButtonTheme: AppButtonTheme.outlined(Brightness.dark),
    filledButtonTheme: AppButtonTheme.filled(Brightness.dark),
    iconButtonTheme: AppIconButtonTheme.data,
    colorScheme: const ColorScheme.dark(
      primary: primaryGreen,
      onPrimary: interactiveTextColor,
      secondary: secondaryGreen,
      error: errorDark,
      onError: interactiveTextColor,
      surface: secondaryDark,
      surfaceDim: backgroundDark,
      surfaceContainer: secondaryDark,
      surfaceContainerLowest: raisedSurfaceDark,
      surfaceBright: skeletonBaseDark,
      surfaceContainerHigh: skeletonHighlightDark,
      onSurface: textDark,
      onSurfaceVariant: mutedTextDark,
      outline: borderColorDark,
      inverseSurface: Colors.white,
      onInverseSurface: Colors.black,
      tertiary: Color.fromARGB(255, 126, 126, 126),
    ),
  );
}
