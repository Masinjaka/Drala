import 'package:flutter/widgets.dart';

/// Keeps a home tab alive while hidden, without animating or taking focus.
class HomeTabSlot extends StatelessWidget {
  const HomeTabSlot({required this.active, required this.child, super.key});

  final bool active;
  final Widget child;

  @override
  Widget build(BuildContext context) => Offstage(
        offstage: !active,
        child: TickerMode(
          enabled: active,
          child: ExcludeFocus(excluding: !active, child: child),
        ),
      );
}
