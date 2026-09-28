import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SlidingDrawerLayout extends StatelessWidget {
  const SlidingDrawerLayout({
    required this.controller,
    required this.drawerWidth,
    required this.drawer,
    required this.home,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onDragCancel,
    this.maximumDimming = 0.59,
    super.key,
  });

  final AnimationController controller;
  final double drawerWidth;
  final Widget drawer;
  final Widget home;
  final void Function(DragUpdateDetails details) onDragUpdate;
  final void Function(DragEndDetails details) onDragEnd;
  final VoidCallback onDragCancel;
  final double maximumDimming;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _dragSurface(
          key: const Key('home-drag-surface'),
          behavior: HitTestBehavior.deferToChild,
          child: Stack(
            fit: StackFit.expand,
            children: [
              KeyedSubtree(key: const Key('home-page-panel'), child: home),
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) => IgnorePointer(
                  ignoring: controller.value == 0,
                  child: GestureDetector(
                    onTap: controller.reverse,
                    child: ColoredBox(
                      key: const Key('home-dim-overlay'),
                      color: Color.fromRGBO(
                          36, 36, 36, maximumDimming * controller.value),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: drawerWidth,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Transform.translate(
              key: const Key('drawer-panel'),
              offset: Offset(drawerWidth * (controller.value - 1), 0),
              child: _dragSurface(
                key: const Key('drawer-drag-surface'),
                child: child!,
              ),
            ),
            child: drawer,
          ),
        ),
      ],
    );
  }

  Widget _dragSurface({
    required Key key,
    required Widget child,
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) {
    return GestureDetector(
      key: key,
      behavior: behavior,
      dragStartBehavior: DragStartBehavior.down,
      onHorizontalDragStart: (_) => controller.stop(),
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      onHorizontalDragCancel: onDragCancel,
      child: child,
    );
  }
}
