import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:flutter/material.dart';

class EnvelopeEmptyState extends StatelessWidget {
  const EnvelopeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStatePhrase(
      title: context.l10n.noEnvelopesYet,
      brief: true,
      illustrationAsset: 'assets/illustrations/empty_states/envelopes.png',
    );
  }
}
