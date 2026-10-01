import 'package:flutter/widgets.dart';

/// Holds the banner offscreen during the calendar's reveal gesture, including
/// that gesture's ballistic motion. The next drag can scroll it back naturally.
class HomeScrollPhysics extends AlwaysScrollableScrollPhysics {
  const HomeScrollPhysics({required this.bannerFloor, super.parent});

  final double? Function() bannerFloor;

  @override
  HomeScrollPhysics applyTo(ScrollPhysics? ancestor) => HomeScrollPhysics(
        bannerFloor: bannerFloor,
        parent: buildParent(ancestor),
      );

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    final floor = bannerFloor();
    if (floor != null && value < floor && value < position.pixels) {
      return value - (position.pixels < floor ? position.pixels : floor);
    }
    return super.applyBoundaryConditions(position, value);
  }
}
