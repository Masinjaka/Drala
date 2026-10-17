import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class ActivityEmptyState extends StatelessWidget {
  const ActivityEmptyState({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 270,
        child: EmptyStatePhrase(
          title: context.l10n.noActivitiesForDay,
          brief: true,
          illustrationAsset: 'assets/illustrations/empty_states/activities.png',
        ),
      );
}
