import 'package:flutter/material.dart';

class SetupProgressDots extends StatelessWidget {
  const SetupProgressDots({required this.currentStep, super.key});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var step = 2; step <= 6; step++) ...[
          if (step > 2) const SizedBox(width: 4),
          AnimatedContainer(
            key: ValueKey('setup-progress-$step'),
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: step == currentStep ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: step == currentStep
                  ? colors.primary
                  : colors.onSurface.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ],
      ],
    );
  }
}
