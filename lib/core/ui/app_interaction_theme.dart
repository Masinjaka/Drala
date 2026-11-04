import 'package:flutter/material.dart';

abstract final class AppInteractionTheme {
  static final _pressedOverlay = WidgetStateProperty.resolveWith<Color?>(
    (states) =>
        states.contains(WidgetState.pressed) ? Colors.transparent : null,
  );
  static final _buttonStyle = ButtonStyle(
    overlayColor: _pressedOverlay,
    splashFactory: NoSplash.splashFactory,
  );

  static ButtonStyle withoutPressFeedback(ButtonStyle style) =>
      _buttonStyle.merge(style);

  static ThemeData withoutInkFeedback(BuildContext context) =>
      apply(Theme.of(context));

  static ThemeData apply(ThemeData theme) => theme.copyWith(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: withoutPressFeedback(
                theme.elevatedButtonTheme.style ?? const ButtonStyle())),
        filledButtonTheme: FilledButtonThemeData(
            style: withoutPressFeedback(
                theme.filledButtonTheme.style ?? const ButtonStyle())),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: withoutPressFeedback(
                theme.outlinedButtonTheme.style ?? const ButtonStyle())),
        textButtonTheme: TextButtonThemeData(
            style: withoutPressFeedback(
                theme.textButtonTheme.style ?? const ButtonStyle())),
        iconButtonTheme: IconButtonThemeData(
            style: withoutPressFeedback(
                theme.iconButtonTheme.style ?? const ButtonStyle())),
        menuButtonTheme: MenuButtonThemeData(
            style: withoutPressFeedback(
                theme.menuButtonTheme.style ?? const ButtonStyle())),
        segmentedButtonTheme: SegmentedButtonThemeData(
            style: withoutPressFeedback(
                theme.segmentedButtonTheme.style ?? const ButtonStyle())),
        tabBarTheme: theme.tabBarTheme.copyWith(
            splashFactory: NoSplash.splashFactory,
            overlayColor: _pressedOverlay),
        floatingActionButtonTheme: theme.floatingActionButtonTheme
            .copyWith(splashColor: Colors.transparent),
        toggleButtonsTheme: theme.toggleButtonsTheme.copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
      );
}
