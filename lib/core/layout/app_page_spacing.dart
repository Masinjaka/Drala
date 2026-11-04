import 'package:flutter/widgets.dart';

/// Shared outer gutter for pages and the resting bottom navigation bar.
abstract final class AppPageSpacing {
  static double horizontal(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 360 ? 16 : 24;

  static EdgeInsets insets(BuildContext context,
      {double top = 0, double bottom = 0}) {
    final gutter = horizontal(context);
    return EdgeInsets.fromLTRB(gutter, top, gutter, bottom);
  }
}
