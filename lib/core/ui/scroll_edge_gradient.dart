import 'package:flutter/material.dart';

/// A paint-only fade that never intercepts list gestures or accessibility.
class ScrollEdgeGradient extends StatelessWidget {
  const ScrollEdgeGradient({this.top = false, super.key});

  final bool top;
  static const height = 40.0;

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).scaffoldBackgroundColor;
    return IgnorePointer(
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: top ? Alignment.topCenter : Alignment.bottomCenter,
                end: top ? Alignment.bottomCenter : Alignment.topCenter,
                colors: [background, background.withValues(alpha: 0)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
