import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_amount.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_overspend_warning.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_progress.dart';
import 'package:flutter/material.dart';

class EnvelopeCard extends StatelessWidget {
  const EnvelopeCard({
    required this.envelope,
    required this.onDelete,
    this.displayCurrency,
    this.onTap,
    this.loading = false,
    super.key,
  });

  final Envelope envelope;
  final VoidCallback? onTap;
  final bool loading;
  final VoidCallback onDelete;
  final CurrencyState? displayCurrency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = theme.colorScheme.onSurface;
    return Column(
      children: [
        GestureDetector(
          onTap: loading ? null : onTap,
          onLongPress: loading ? null : (onTap ?? onDelete),
          child: Container(
            key: const Key('envelope-card-surface'),
            padding: const EdgeInsets.fromLTRB(22, 16, 14, 26),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text('${envelope.emoji} ${envelope.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium)),
                    if (envelope.isExceeded && !loading) ...[
                      const SizedBox(width: 8),
                      Flexible(
                          child: EnvelopeOverspendWarning(
                              envelope: envelope,
                              displayCurrency: displayCurrency)),
                    ],
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (loading)
                      const ValueSkeleton(
                        key: Key('envelope-spent-skeleton'),
                        width: 64,
                        height: 18,
                      )
                    else
                      Flexible(
                          child: FittedBox(
                              child: EnvelopeAmount(
                        value: _convert(envelope.spent),
                        currencyCode:
                            displayCurrency?.code ?? envelope.currencyCode,
                      ))),
                    const SizedBox(width: 12),
                    if (loading)
                      const ValueSkeleton(
                        key: Key('envelope-budget-skeleton'),
                        width: 56,
                        height: 18,
                      )
                    else
                      Flexible(
                          child: FittedBox(
                              child: EnvelopeAmount(
                        value: _convert(envelope.amount),
                        gap: false,
                        currencyCode:
                            displayCurrency?.code ?? envelope.currencyCode,
                      ))),
                  ],
                ),
                const SizedBox(height: 10),
                if (loading)
                  const ValueSkeleton(width: double.infinity, height: 12)
                else
                  EnvelopeProgress(
                    value: envelope.progress.clamp(0, 1),
                    foregroundColor: foreground,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  num _convert(num amount) =>
      displayCurrency?.convertToSelected(
        amount,
        envelope.currencyCode,
      ) ??
      amount;
}
