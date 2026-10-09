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
    final progress = value.clamp(0.0, 1.0);
    return LayoutBuilder(builder: (context, constraints) {
      final gap = progress > 0 && progress < 1 ? 6.0 : 0.0;
      final available =
          (constraints.maxWidth - gap).clamp(0.0, double.infinity);
      return Row(children: [
        if (progress > 0)
          Container(
            width: available * progress,
            height: 9,
            decoration: BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        if (gap > 0) SizedBox(width: gap),
        if (progress < 1)
          Expanded(
            child: Container(
              height: 9,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
      ]);
    });
  }
}
