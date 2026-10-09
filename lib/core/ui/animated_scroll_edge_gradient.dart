import 'package:flutter/material.dart';
import 'scroll_edge_gradient.dart';

/// Keeps the edge mounted so visibility changes can animate in both directions.
class AnimatedScrollEdgeGradient extends StatelessWidget {
  const AnimatedScrollEdgeGradient({
    required this.visible,
    this.top = false,
    super.key,
  });

  final bool visible;
  final bool top;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: visible ? 1 : 0),
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        child: ScrollEdgeGradient(top: top),
        builder: (context, opacity, child) => opacity == 0
            ? const SizedBox(height: ScrollEdgeGradient.height)
            : Opacity(opacity: opacity, child: child),
      );
}
