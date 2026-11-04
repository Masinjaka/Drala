import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
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
    final compact = MediaQuery.sizeOf(context).height < 700 ||
        MediaQuery.textScalerOf(context).scale(1) > 1.3;
    return Padding(
      padding: AppPageSpacing.insets(context,
          top: AppHeaderMetrics.topPadding, bottom: compact ? 12 : 27),
      child: SizedBox(
        height: AppHeaderMetrics.buttonSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (onBack != null || showDisabledBack)
              Align(
                alignment: Alignment.centerLeft,
                child: CustomButton.icon(
                  icon: Icons.arrow_back_rounded,
                  iconSize: AppHeaderMetrics.iconSize,
                  width: AppHeaderMetrics.buttonSize,
                  height: AppHeaderMetrics.buttonSize,
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
