import 'package:flutter/material.dart';
import 'app_page_spacing.dart';

abstract final class AppScrollPadding {
  static EdgeInsets insets(BuildContext context,
          {double top = 0, double bottom = 0}) =>
      AppPageSpacing.insets(context,
          top: top, bottom: trailing(context, bottom));

  static double trailing(BuildContext context, double gap) {
    return gap + MediaQuery.paddingOf(context).bottom;
  }
}
