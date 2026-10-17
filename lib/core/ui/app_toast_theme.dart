import 'package:flutter/material.dart';

class AppToastTheme extends ThemeExtension<AppToastTheme> {
  const AppToastTheme({
    required this.background,
    required this.foreground,
    required this.success,
    required this.error,
    required this.info,
    required this.iconForeground,
  });

  final Color background;
  final Color foreground;
  final Color success;
  final Color error;
  final Color info;
  final Color iconForeground;

  static const light = AppToastTheme(
    background: Color(0xFF303030),
    foreground: Color(0xFFFFFFFF),
    success: Color(0xFF91E7A4),
    error: Color(0xFFE86468),
    info: Color(0xFFFFCF52),
    iconForeground: Color(0xFF303030),
  );

  static const dark = AppToastTheme(
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF333333),
    success: Color(0xFF70C485),
    error: Color(0xFFE86468),
    info: Color(0xFFF0C447),
    iconForeground: Color(0xFF303030),
  );

  @override
  AppToastTheme copyWith({
    Color? background,
    Color? foreground,
    Color? success,
    Color? error,
    Color? info,
    Color? iconForeground,
  }) =>
      AppToastTheme(
        background: background ?? this.background,
        foreground: foreground ?? this.foreground,
        success: success ?? this.success,
        error: error ?? this.error,
        info: info ?? this.info,
        iconForeground: iconForeground ?? this.iconForeground,
      );

  @override
  AppToastTheme lerp(ThemeExtension<AppToastTheme>? other, double t) {
    if (other is! AppToastTheme) return this;
    return AppToastTheme(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      iconForeground: Color.lerp(iconForeground, other.iconForeground, t)!,
    );
  }
}
