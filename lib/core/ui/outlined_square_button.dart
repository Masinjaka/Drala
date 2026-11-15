import 'package:budgets/core/ui/app_header_button_shadow.dart';
import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class OutlinedSquareButton extends StatefulWidget {
  const OutlinedSquareButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.visualSize = AppHeaderMetrics.buttonSize,
    this.iconSize = AppHeaderMetrics.iconSize,
    this.hitTargetSize = AppHeaderMetrics.buttonSize,
    this.backgroundColor,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final double visualSize;
  final double iconSize;
  final double hitTargetSize;
  final Color? backgroundColor;

  @override
  State<OutlinedSquareButton> createState() => _OutlinedSquareButtonState();
}

class _OutlinedSquareButtonState extends State<OutlinedSquareButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.06),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.06, end: 0.96),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.96, end: 1),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handlePressed() {
    _pressController.forward(from: 0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = widget.backgroundColor ??
        (isDark ? theme.colorScheme.surfaceContainerLowest : theme.cardColor);
    return SizedBox.square(
      dimension: widget.hitTargetSize,
      child: Center(
        child: ScaleTransition(
          scale: _scale,
          child: AppHeaderButtonShadow(
              child: CustomButton.icon(
            icon: widget.icon,
            iconSize: widget.iconSize,
            width: widget.visualSize,
            height: widget.visualSize,
            backgroundColor: background,
            foregroundColor:
                isDark ? AppTheme.homeBannerText : theme.colorScheme.onSurface,
            tooltip: widget.tooltip,
            onPressed: _handlePressed,
          )),
        ),
      ),
    );
  }
}
