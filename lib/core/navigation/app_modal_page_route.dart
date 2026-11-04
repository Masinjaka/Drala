import 'package:flutter/material.dart';

/// Full-screen secondary destinations rise from the bottom and dismiss downward.
class AppModalPageRoute<T> extends PageRouteBuilder<T> {
  AppModalPageRoute({required WidgetBuilder builder, super.settings})
      : super(
          fullscreenDialog: true,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, _, __) => builder(context),
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position:
                Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
              CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                  reverseCurve: Curves.easeInCubic),
            ),
            child: child,
          ),
        );
}
