import 'package:flutter/material.dart';
import 'app_card_theme.dart';
import 'app_header_scope.dart';

abstract final class AppHeaderTheme {
  static List<BoxShadow> buttonShadows(BuildContext context) =>
      AppCardTheme.shadows(context)
          .map((shadow) => shadow.copyWith(
                color: shadow.color.withValues(alpha: shadow.color.a * .65),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ))
          .toList(growable: false);
  static List<Shadow>? titleShadows(BuildContext context) =>
      !AppHeaderScope.contains(context)
          ? null
          : AppCardTheme.shadows(context)
              .map((shadow) => Shadow(
                  color: shadow.color,
                  blurRadius: 3,
                  offset: const Offset(0, 1)))
              .toList(growable: false);
}
