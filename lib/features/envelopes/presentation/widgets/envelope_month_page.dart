import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_list_panel.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_list_skeleton.dart';
import 'package:flutter/material.dart';

class EnvelopeMonthPage extends StatelessWidget {
  const EnvelopeMonthPage({
    required this.envelopes,
    required this.isLoading,
    required this.onRefresh,
    required this.onDelete,
    this.displayCurrency,
    this.targetEnvelopeId,
    super.key,
  });

  final List<Envelope> envelopes;
  final bool isLoading;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onDelete;
  final CurrencyState? displayCurrency;
  final String? targetEnvelopeId;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        key: const Key('envelope-month-list'),
        padding: const EdgeInsets.fromLTRB(29, 0, 29, 32),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (isLoading)
            const EnvelopeListSkeleton()
          else
            EnvelopeListPanel(
              envelopes: envelopes,
              onDelete: onDelete,
              displayCurrency: displayCurrency,
              targetEnvelopeId: targetEnvelopeId,
            ),
        ],
      ),
    );
  }
}
