import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
import 'app_close_button.dart';
import 'app_finance_surface_theme.dart';
import 'package:flutter/material.dart';

class DetailPageHeader extends StatelessWidget {
  const DetailPageHeader({
    required this.title,
    this.onAdd,
    this.showBackButton = true,
    this.addTooltip,
    this.buttonVisualSize = AppHeaderMetrics.buttonSize,
    this.buttonIconSize = AppHeaderMetrics.iconSize,
    super.key,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onAdd;
  final String? addTooltip;
  final double buttonVisualSize;
  final double buttonIconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppFinanceSurfaceTheme.title(context),
            ),
          ),
        ),
        if (showBackButton) ...[
          const SizedBox(width: 8),
          AppCloseButton(
              key: const Key('detail-page-close'),
              onPressed: () => Navigator.maybePop(context)),
        ],
        if (onAdd != null) ...[
          const SizedBox(width: AppHeaderMetrics.titleGap),
          OutlinedSquareButton(
            key: const Key('detail-add-button'),
            icon: Icons.add_rounded,
            visualSize: buttonVisualSize,
            iconSize: buttonIconSize,
            onPressed: onAdd!,
            tooltip: addTooltip,
          ),
        ],
      ],
    );
  }
}
