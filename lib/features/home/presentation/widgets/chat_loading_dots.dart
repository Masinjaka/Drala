import 'dart:math' as math;

import 'package:flutter/material.dart';

class ChatLoadingDots extends StatefulWidget {
  const ChatLoadingDots({required this.color, super.key});

  final Color color;

  @override
  State<ChatLoadingDots> createState() => _ChatLoadingDotsState();
}

class _ChatLoadingDotsState extends State<ChatLoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 17,
      height: 10,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, _buildDot),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    final phase = (_controller.value - index * 0.16) * math.pi * 2;
    final offset = -math.max(0.0, math.sin(phase)) * 3.0;
    return Transform.translate(
      offset: Offset(0, offset),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
        child: const SizedBox.square(dimension: 3),
      ),
    );
  }
}
