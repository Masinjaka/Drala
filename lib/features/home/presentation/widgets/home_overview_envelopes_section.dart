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
      required this.onEnvelopes,
      required this.onCreate,
      this.currency,
      super.key});
  final List<Envelope> envelopes;
  final bool loading;
  final VoidCallback onEnvelopes;
  final VoidCallback onCreate;
  final CurrencyState? currency;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeOverviewSectionHeader(
              showSeeMore: envelopes.isNotEmpty,
              title: context.l10n.envelopes,
              onSeeMore: onEnvelopes),
          if (loading && envelopes.isEmpty)
            const LinearProgressIndicator()
          else if (envelopes.isEmpty)
            HomeOverviewEmptyState(
                key: const Key('home-empty-envelopes'),
                title: context.l10n.noEnvelopesYet,
                asset: 'assets/illustrations/empty_states/home_envelopes.png',
                actionLabel: context.l10n.createEnvelope,
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
      );
}
