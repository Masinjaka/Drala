import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// The app's short, staggered list entrance; replay preserves child state.
class ListItemEntrance extends StatefulWidget {
  const ListItemEntrance(
      {required this.index, required this.child, this.replayKey, super.key});
  final int index;
  final Object? replayKey;
  final Widget child;
  @override
  State<ListItemEntrance> createState() => _ListItemEntranceState();
}

class _ListItemEntranceState extends State<ListItemEntrance> {
  AnimationController? _controller;
  Timer? _delay;
  Duration get _stagger =>
      Duration(milliseconds: widget.index < 3 ? 25 * widget.index : 0);
  @override
  void didUpdateWidget(ListItemEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.replayKey != oldWidget.replayKey &&
        !MediaQuery.disableAnimationsOf(context)) {
      _delay?.cancel();
      _controller?.reset();
      _delay = Timer(_stagger, () {
        if (mounted) _controller?.forward();
      });
    }
  }

  @override
  void dispose() {
    _delay?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return widget.child
        .animate(
            delay: _stagger, onInit: (controller) => _controller = controller)
        .fadeIn(duration: 180.ms)
        .slideY(begin: .15, duration: 180.ms, curve: Curves.easeOutCubic);
  }
}
