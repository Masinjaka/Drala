import 'package:flutter/material.dart';

/// The shared position-driven pill used by category and entry tab controls.
class SlidingTabIndicator extends StatelessWidget {
  const SlidingTabIndicator(
      {required this.animation,
      required this.count,
      required this.color,
      required this.radius,
      super.key});
  static const duration = Duration(milliseconds: 260);
  static const curve = Curves.easeOutCubic;
  final Animation<double> animation;
  final int count;
  final Color color;
  final BorderRadius radius;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final position = animation.value.clamp(0.0, (count - 1).toDouble());
        final x = count == 1 ? 0.0 : -1 + 2 * position / (count - 1);
        return Align(
            alignment: AlignmentDirectional(x, 0),
            child: FractionallySizedBox(
                widthFactor: 1 / count,
                heightFactor: 1,
                child: DecoratedBox(
                    decoration:
                        BoxDecoration(color: color, borderRadius: radius))));
      });
}
