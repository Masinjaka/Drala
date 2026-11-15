import 'package:budgets/core/widgets/delayed_skeleton.dart';
import 'home_overview_envelope_skeleton.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_empty_state.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_envelope_card.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_section_header.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeOverviewEnvelopesSection extends StatelessWidget {
  const HomeOverviewEnvelopesSection(
      {required this.envelopes,
      required this.loading,
      this.resolved = true,
      required this.onEnvelopes,
      required this.onCreate,
      this.currency,
      super.key});
  final List<Envelope> envelopes;
  final bool loading;
  final bool resolved;
  final VoidCallback onEnvelopes;
  final VoidCallback onCreate;
  final CurrencyState? currency;

  @override
  Widget build(BuildContext context) => DelayedSkeleton(
      pending: loading && envelopes.isEmpty,
      builder: (context, showSkeleton) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeOverviewSectionHeader(
                  showSeeMore: envelopes.isNotEmpty,
                  reserveActionSpace: loading,
                  title: context.l10n.envelopes,
                  onSeeMore: onEnvelopes),
              if (showSkeleton)
                const Row(children: [
                  Expanded(child: HomeOverviewEnvelopeSkeleton()),
                  SizedBox(width: 16),
                  Expanded(child: HomeOverviewEnvelopeSkeleton()),
                ])
              else if (envelopes.isEmpty && resolved)
                HomeOverviewEmptyState(
                    key: const Key('home-empty-envelopes'),
                    message: context.l10n.homeEmptyEnvelopeMessage,
                    asset: 'assets/illustrations/empty_states/envelopes.png',
                    actionLabel: context.l10n.homeEmptyEnvelopeAction,
                    actionKey: const Key('home-create-envelope'),
                    onPressed: onCreate)
              else
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (var i = 0; i < envelopes.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    Expanded(
                        child: HomeOverviewEnvelopeCard(
                            envelope: envelopes[i],
                            currency: currency,
                            onPressed: onEnvelopes)),
                  ],
                  if (envelopes.length == 1) const Spacer(),
                ]),
            ],
          ));
}
