import 'package:flutter/material.dart';

abstract final class AppCardTheme {
  static List<BoxShadow> shadows(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).shadowColor.withValues(
              alpha:
                  Theme.of(context).brightness == Brightness.dark ? .22 : .07),
          blurRadius: 18,
          offset: const Offset(0, 4),
        ),
      ];
}
