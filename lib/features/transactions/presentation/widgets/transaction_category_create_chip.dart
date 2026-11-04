import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_border_painter.dart';
import 'package:flutter/material.dart';

class TransactionCategoryCreateChip extends StatelessWidget {
  const TransactionCategoryCreateChip({required this.onTap, super.key});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => CustomPaint(
      painter: DashedBorderPainter(
          color: AppFinanceSurfaceTheme.action(context),
          strokeWidth: 1,
          borderRadius: 24),
      child: InkWell(
          key: const Key('category-create'),
          onTap: onTap,
          borderRadius: AppFinanceSurfaceTheme.fieldRadius,
          child: ConstrainedBox(
              constraints: const BoxConstraints(
                  minHeight: AppFinanceSurfaceTheme.selectionHeight),
              child: Padding(
                  padding: AppFinanceSurfaceTheme.selectionPadding,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.add, size: 18),
                    const SizedBox(width: 6),
                    Text(context.l10n.create,
                        style: Theme.of(context).textTheme.labelSmall),
                  ])))));
}
