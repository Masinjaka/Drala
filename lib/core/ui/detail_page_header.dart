import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:flutter/material.dart';

class DetailPageHeader extends StatelessWidget {
  const DetailPageHeader({
    required this.title,
    this.onAdd,
    this.addTooltip,
    this.buttonVisualSize = AppControlMetrics.squareButtonVisualSize,
    this.buttonIconSize = 22,
    super.key,
  });

  final String title;
  final VoidCallback? onAdd;
  final String? addTooltip;
  final double buttonVisualSize;
  final double buttonIconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedSquareButton(
          icon: Icons.arrow_back_rounded,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          visualSize: buttonVisualSize,
          iconSize: buttonIconSize,
          onPressed: () => Navigator.maybePop(context),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        (onAdd != null)
            ? OutlinedSquareButton(
                key: const Key('detail-add-button'),
                icon: Icons.add_rounded,
                visualSize: buttonVisualSize,
                iconSize: buttonIconSize,
                onPressed: onAdd!,
                tooltip: addTooltip,
              )
            : SizedBox.square(dimension: AppControlMetrics.iconButtonSize),
      ],
    );
  }
}
