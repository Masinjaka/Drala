import 'dart:async';

import 'package:flutter/widgets.dart';

/// Lets a cold request finish before mounting an animated skeleton.
class DelayedSkeleton extends StatefulWidget {
  const DelayedSkeleton({
    required this.pending,
    required this.builder,
    this.requestKey,
    super.key,
  });

  final bool pending;
  final Object? requestKey;
  final Widget Function(BuildContext, bool showSkeleton) builder;

  @override
  State<DelayedSkeleton> createState() => _DelayedSkeletonState();
}

class _DelayedSkeletonState extends State<DelayedSkeleton> {
  Timer? _timer;
  bool _show = false;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  @override
  void didUpdateWidget(covariant DelayedSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pending != oldWidget.pending ||
        widget.requestKey != oldWidget.requestKey) {
      _restart();
    }
  }

  void _restart() {
    _timer?.cancel();
    _show = false;
    if (widget.pending) {
      _timer = Timer(const Duration(milliseconds: 200),
          () => setState(() => _show = true));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _show);
}
