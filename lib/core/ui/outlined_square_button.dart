import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:flutter/material.dart';

class OutlinedSquareButton extends StatelessWidget {
  const OutlinedSquareButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.visualSize = AppControlMetrics.iconButtonSize,
    this.iconSize = AppControlMetrics.iconSize,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final double visualSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppControlMetrics.iconButtonSize,
      child: Center(
          child: IconButton.outlined(
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          minimumSize: Size.square(visualSize),
          maximumSize: Size.square(visualSize),
          tapTargetSize: MaterialTapTargetSize.padded,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          side: BorderSide(color: Theme.of(context).colorScheme.onSurface),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(icon, size: iconSize),
      )),
    );
  }
}
