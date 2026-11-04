import 'package:flutter/material.dart';

abstract final class AppGridTheme {
  static Color lines(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? .16 : .09);
}
