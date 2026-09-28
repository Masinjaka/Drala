import 'package:flutter/material.dart';

class EnvelopeProgress extends StatelessWidget {
  const EnvelopeProgress({
    required this.value,
    required this.foregroundColor,
    super.key,
  });

  final double value;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 9,
              color: foregroundColor,
              backgroundColor: foregroundColor.withValues(alpha: .22),
            ),
          ),
          Align(
            alignment: Alignment((value * 2 - 1).clamp(-.96, .96), 0),
            child: Container(width: 5, height: 20, color: foregroundColor),
          ),
        ],
      ),
    );
  }
}
