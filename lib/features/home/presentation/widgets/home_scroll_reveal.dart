import 'package:flutter/material.dart';

class HomeScrollReveal extends StatelessWidget {
  const HomeScrollReveal({
    required this.visibility,
    required this.child,
    this.alignment = -1,
    this.minimumSizeFactor = 0,
    super.key,
  });

  final Animation<double> visibility;
  final Widget child;
  final double alignment;
  final double minimumSizeFactor;

  @override
  Widget build(BuildContext context) {
    final sizeFactor =
        Tween<double>(begin: minimumSizeFactor, end: 1).animate(visibility);
    return AnimatedBuilder(
      animation: visibility,
      child: child,
      builder: (context, child) => IgnorePointer(
        ignoring: visibility.value < 0.99,
        child: ExcludeSemantics(
          excluding: visibility.value < 0.99,
          child: SizeTransition(
            sizeFactor: sizeFactor,
            axisAlignment: alignment,
            child: FadeTransition(opacity: visibility, child: child),
          ),
        ),
      ),
    );
  }
}
