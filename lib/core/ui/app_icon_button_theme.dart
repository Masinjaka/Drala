import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:flutter/material.dart';

abstract final class AppIconButtonTheme {
  static final data = IconButtonThemeData(
    style: IconButton.styleFrom(
      minimumSize: const Size.square(AppControlMetrics.iconButtonSize),
      iconSize: AppControlMetrics.iconSize,
      tapTargetSize: MaterialTapTargetSize.padded,
    ),
  );
}
