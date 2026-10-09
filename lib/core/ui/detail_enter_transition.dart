import 'package:flutter/material.dart';

class DetailEnterTransition extends StatelessWidget {
  const DetailEnterTransition({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: child,
        builder: (_, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
                offset: Offset(0, 16 * (1 - value)), child: child)),
      );
}
