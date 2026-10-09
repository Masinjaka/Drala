import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SetupListChoiceEntrance extends StatelessWidget {
  const SetupListChoiceEntrance({
    required this.index,
    required this.child,
    super.key,
  });

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return child
        .animate(delay: (index < 3 ? 25 * index : 0).ms)
        .fadeIn(duration: 180.ms)
        .slideY(begin: 0.15, duration: 180.ms, curve: Curves.easeOutCubic);
  }
}
