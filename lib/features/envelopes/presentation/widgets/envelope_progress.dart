import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/features/envelopes/presentation/widgets/paper_grain_painter.dart';

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
        borderRadius: AppEnvelopeTheme.progressRadius,
        child: SizedBox(
            width: double.infinity,
            height: AppEnvelopeTheme.progressHeight,
            child: Stack(children: [
              Positioned.fill(
                  child: ColoredBox(
                      color: AppEnvelopeTheme.progressTrack(context))),
              FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                      key: const Key('envelope-progress-fill'),
                      height: AppEnvelopeTheme.progressHeight,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: foregroundColor,
                          borderRadius: AppEnvelopeTheme.progressRadius),
                      // Cached as its own layer so the grain is painted once.
                      child: const RepaintBoundary(
                          child: CustomPaint(
                              size: Size.infinite,
                              painter: PaperGrainPainter(
                                  light: AppEnvelopeTheme.progressGrainLight,
                                  dark: AppEnvelopeTheme.progressGrainDark,
                                  density: AppEnvelopeTheme
                                      .progressGrainDensity))))),
            ])));
  }
}
