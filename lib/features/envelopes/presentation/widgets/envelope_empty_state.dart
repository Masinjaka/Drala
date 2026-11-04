import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';

class EnvelopeEmptyState extends StatelessWidget {
  const EnvelopeEmptyState({this.onAdd, super.key});
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return EmptyStatePhrase(
      title: context.l10n.noEnvelopesYet,
      brief: true,
      action: onAdd == null
          ? null
          : EmptyStateAction(
              label: context.l10n.createEnvelope, onPressed: onAdd!),
      illustrationAsset: 'assets/illustrations/empty_states/envelopes.png',
    );
  }
}
