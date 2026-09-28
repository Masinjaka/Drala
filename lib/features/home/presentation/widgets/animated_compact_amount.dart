import 'dart:async';

import 'package:animated_digit/animated_digit.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:flutter/material.dart';

class AnimatedCompactAmount extends StatefulWidget {
  const AnimatedCompactAmount({
    required this.value,
    required this.style,
    this.prefix = '',
    this.duration = const Duration(milliseconds: 800),
    this.onCompleted,
    this.beginNearTarget = false,
    super.key,
  });

  final num value;
  final String prefix;
  final TextStyle style;
  final Duration duration;
  final VoidCallback? onCompleted;
  final bool beginNearTarget;

  @override
  State<AnimatedCompactAmount> createState() => _AnimatedCompactAmountState();
}

class _AnimatedCompactAmountState extends State<AnimatedCompactAmount> {
  late AnimatedDigitController _controller;
  late ({double divisor, String suffix, int fractionDigits}) _display;
  late Widget _counter;
  Timer? _completionTimer;

  @override
  void initState() {
    super.initState();
    _display = _displayFor(widget.value);
    _controller = AnimatedDigitController(
      _initialValue(widget.value) / _display.divisor,
    );
    _counter = _buildCounter();
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateToTarget());
  }

  @override
  void didUpdateWidget(AnimatedCompactAmount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == widget.value) {
      if (oldWidget.prefix != widget.prefix ||
          oldWidget.style != widget.style ||
          oldWidget.duration != widget.duration) {
        _counter = _buildCounter();
      }
      return;
    }
    final nextDisplay = _displayFor(widget.value);
    if (nextDisplay.divisor != _display.divisor) {
      _controller.dispose();
      _display = nextDisplay;
      _controller = AnimatedDigitController(
        _initialValue(widget.value) / _display.divisor,
      );
      _counter = _buildCounter();
      WidgetsBinding.instance.addPostFrameCallback((_) => _animateToTarget());
      return;
    }
    _display = nextDisplay;
    _counter = _buildCounter();
    _animateToTarget();
  }

  num _initialValue(num target) {
    if (!widget.beginNearTarget) return 0;
    if (target > 200) return target - 200;
    if (target < -200) return target + 200;
    return 0;
  }

  void _animateToTarget() {
    if (!mounted) return;
    _controller.resetValue(widget.value / _display.divisor);
    _completionTimer?.cancel();
    _completionTimer = Timer(widget.duration, () {
      if (mounted) widget.onCompleted?.call();
    });
  }

  ({double divisor, String suffix, int fractionDigits}) _displayFor(
    num value,
  ) {
    final absolute = value.abs();
    final (divisor, suffix) = absolute >= 1000000
        ? (1000000.0, 'M')
        : absolute >= 1000
            ? (1000.0, 'K')
            : (1.0, '');
    final scaled = value / divisor;
    return (
      divisor: divisor,
      suffix: suffix,
      fractionDigits: scaled % 1 == 0 ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _completionTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AmountVisibilityScope.isVisibleOf(context)) {
      return Text('***', maxLines: 1, style: widget.style);
    }
    return _counter;
  }

  Widget _buildCounter() {
    return SingleDigitProvider(
      data: SingleDigitData(useTextSize: true),
      child: AnimatedDigitWidget(
        controller: _controller,
        textStyle: widget.style,
        prefix: widget.prefix,
        suffix: _display.suffix,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        fractionDigits: _display.fractionDigits,
        loop: false,
        firstScrollAnimate: false,
      ),
    );
  }
}
