import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:flutter/material.dart';

abstract final class AppIconButtonTheme {
  static IconButtonThemeData data(Brightness brightness) => IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppControlMetrics.iconButtonSize),
          iconSize: AppControlMetrics.iconSize,
          tapTargetSize: MaterialTapTargetSize.padded,
          foregroundColor: brightness == Brightness.dark ? Colors.white : null,
          disabledForegroundColor:
              brightness == Brightness.dark ? Colors.white : null,
        ),
      );
}
