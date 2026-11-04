import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_envelope_theme.dart';

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
    return ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: SizedBox(
            width: double.infinity,
            height: 5,
            child: Stack(children: [
              Positioned.fill(
                  child: ColoredBox(
                      color: AppEnvelopeTheme.progressTrack(context))),
              FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: foregroundColor,
                          borderRadius: BorderRadius.circular(3)))),
            ])));
  }
}
