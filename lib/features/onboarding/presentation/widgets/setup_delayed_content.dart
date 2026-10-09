import 'package:flutter/material.dart';

class SetupDelayedContent extends StatelessWidget {
  const SetupDelayedContent({
    required this.child,
    required this.delay,
    this.placeholder = const SizedBox.shrink(),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: delay,
      child: child,
      builder: (_, progress, child) => progress < 1 ? placeholder : child!,
    );
  }
}
