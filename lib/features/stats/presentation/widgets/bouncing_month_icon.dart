import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class BouncingMonthIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final VoidCallback? onTap;

  const BouncingMonthIcon({
    required this.icon,
    required this.size,
    this.color,
    this.onTap,
  });

  @override
  State<BouncingMonthIcon> createState() => BouncingMonthIconState();
}

class BouncingMonthIconState extends State<BouncingMonthIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    if (widget.onTap != null) {
      Vibration.vibrate(duration: 15, amplitude: 40);
      widget.onTap!();
    } else {
      // 2-tone subtle vibration to deny the action
      Vibration.vibrate(pattern: [0, 12, 40, 12], intensities: [0, 50, 0, 30]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(widget.icon,
              size: widget.size,
              color: AppIconForeground.resolve(context, widget.color)),
        ),
      ),
    );
  }
}
