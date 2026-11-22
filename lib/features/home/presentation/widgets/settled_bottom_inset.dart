import 'dart:async';

import 'package:flutter/material.dart';

/// Holds the page's bottom padding still while the bottom bar resizes.
///
/// The Scaffold reports the floating bar's height as bottom padding on every
/// animation frame. Passing that through re-lays out every tab, including
/// offstage ones, for each frame. Here the page keeps its previous padding
/// until the transition ends, then takes the final value in a single pass.
class SettledBottomInset extends StatefulWidget {
  const SettledBottomInset({
    required this.trigger,
    required this.duration,
    required this.child,
    super.key,
  });

  /// A change of this value (the selected tab) starts a settling period.
  final Object trigger;
  final Duration duration;
  final Widget child;

  @override
  State<SettledBottomInset> createState() => _SettledBottomInsetState();
}

class _SettledBottomInsetState extends State<SettledBottomInset> {
  Timer? _settle;
  double? _held;

  @override
  void didUpdateWidget(covariant SettledBottomInset oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger == widget.trigger ||
        widget.duration == Duration.zero) {
      return;
    }
    _held ??= MediaQuery.paddingOf(context).bottom;
    _settle?.cancel();
    // A short margin lets the bar's last frame land before the page updates.
    _settle = Timer(widget.duration + const Duration(milliseconds: 32), () {
      if (mounted) setState(() => _held = null);
    });
  }

  @override
  void dispose() {
    _settle?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Always wrap, so the page never changes position in the tree.
    final media = MediaQuery.of(context);
    final held = _held;
    return MediaQuery(
      data: held == null
          ? media
          : media.copyWith(padding: media.padding.copyWith(bottom: held)),
      child: widget.child,
    );
  }
}
