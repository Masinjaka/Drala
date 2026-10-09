import 'package:flutter/material.dart';
import 'animated_scroll_edge_gradient.dart';

/// Wrap a single vertical viewport, inside any horizontal page/tab view.
/// Metrics notifications also handle initial layout, resizing and list changes.
class ScrollEdgeFade extends StatefulWidget {
  const ScrollEdgeFade({required this.child, this.showTop = true, super.key});

  final Widget child;
  final bool showTop;

  @override
  State<ScrollEdgeFade> createState() => _ScrollEdgeFadeState();
}

class _ScrollEdgeFadeState extends State<ScrollEdgeFade> {
  bool _top = false;
  bool _bottom = false;
  bool _scheduled = false;
  bool _nextTop = false;
  bool _nextBottom = false;

  void _update(ScrollMetrics metrics, int depth) {
    if (depth != 0 || metrics.axis != Axis.vertical) return;
    final reversed = metrics.axisDirection == AxisDirection.up;
    _nextTop = (reversed ? metrics.extentAfter : metrics.extentBefore) > 0.5;
    _nextBottom = (reversed ? metrics.extentBefore : metrics.extentAfter) > 0.5;
    if (_scheduled || (_top == _nextTop && _bottom == _nextBottom)) return;
    _scheduled = true;
    // Notifications can arrive during layout; rebuild only on edge changes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (!mounted || (_top == _nextTop && _bottom == _nextBottom)) return;
      setState(() {
        _top = _nextTop;
        _bottom = _nextBottom;
      });
    });
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          _update(notification.metrics, notification.depth);
          return false;
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _update(notification.metrics, notification.depth);
            return false;
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.child,
              if (widget.showTop)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedScrollEdgeGradient(top: true, visible: _top),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedScrollEdgeGradient(visible: _bottom),
              ),
            ],
          ),
        ),
      );
}
