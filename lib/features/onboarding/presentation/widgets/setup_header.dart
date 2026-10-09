import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'setup_progress_dots.dart';

class SetupHeader extends StatelessWidget {
  const SetupHeader({
    required this.currentStep,
    required this.onBack,
    this.showDisabledBack = false,
    super.key,
  });

  final int currentStep;
  final VoidCallback? onBack;
  final bool showDisabledBack;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(29, 48, 29, 27),
      child: SizedBox(
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (onBack != null || showDisabledBack)
              Align(
                alignment: Alignment.centerLeft,
                child: CustomButton.icon(
                  icon: Icons.arrow_back_rounded,
                  iconSize: 20,
                  width: 36,
                  height: 36,
                  borderRadius: BorderRadius.circular(9),
                  backgroundColor: colors.surfaceContainer,
                  foregroundColor: colors.onSurface,
                  onPressed: onBack,
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
              ),
            SetupProgressDots(currentStep: currentStep),
          ],
        ),
      ),
    );
  }
}
