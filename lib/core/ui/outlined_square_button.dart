import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:flutter/material.dart';

class OutlinedSquareButton extends StatelessWidget {
  const OutlinedSquareButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppControlMetrics.iconButtonSize,
      child: IconButton.outlined(
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          side: BorderSide(color: Theme.of(context).colorScheme.onSurface),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: Icon(icon, size: AppControlMetrics.iconSize),
      ),
    );
  }
}
