import 'package:budgets/features/plans/domain/models/plan_feature.dart';
import 'package:flutter/material.dart';

class PlanFeatureRow extends StatelessWidget {
  const PlanFeatureRow({required this.feature, super.key});

  final PlanFeature feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              feature.name,
              style: theme.textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              feature.freeBenefit,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              feature.plusBenefit,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
