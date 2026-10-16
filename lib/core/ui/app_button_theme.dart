import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:flutter/material.dart';

abstract final class AppButtonTheme {
  static ElevatedButtonThemeData elevated(
    Brightness brightness, {
    required Color background,
    required Color foreground,
  }) =>
      ElevatedButtonThemeData(
        style: _filled(brightness, background, foreground),
      );

  static FilledButtonThemeData filled(
    Brightness brightness, {
    required Color background,
    required Color foreground,
  }) =>
      FilledButtonThemeData(
        style: _filled(brightness, background, foreground),
      );

  static OutlinedButtonThemeData outlined(Brightness brightness) =>
      OutlinedButtonThemeData(
        style: _base(brightness).copyWith(
          side: WidgetStatePropertyAll(
            BorderSide(color: _foreground(brightness)),
          ),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      );

  static TextButtonThemeData text(Brightness brightness) => TextButtonThemeData(
        style: _base(brightness),
      );

  static ButtonStyle _filled(
    Brightness brightness,
    Color background,
    Color foreground,
  ) =>
      _base(brightness).copyWith(
        backgroundColor: WidgetStatePropertyAll(background),
        foregroundColor: WidgetStatePropertyAll(foreground),
      );

  static ButtonStyle _base(Brightness brightness) => ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(
          Size(0, AppControlMetrics.height),
        ),
        foregroundColor: WidgetStatePropertyAll(_foreground(brightness)),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: AppTypography.body,
            fontWeight: FontWeight.w800,
          ),
        ),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
      );

  static Color _foreground(Brightness brightness) =>
      brightness == Brightness.dark ? Colors.white : Colors.black;
}
