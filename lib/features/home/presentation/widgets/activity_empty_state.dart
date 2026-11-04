import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';

class ActivityEmptyState extends StatelessWidget {
  const ActivityEmptyState({this.onAdd, super.key});
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 270),
        child: EmptyStatePhrase(
          title: context.l10n.noActivitiesForDay,
          brief: true,
          action: onAdd == null
              ? null
              : EmptyStateAction(
                  label: context.l10n.trackYourBudget, onPressed: onAdd!),
          illustrationAsset: 'assets/illustrations/empty_states/activities.png',
        ),
      );
}
