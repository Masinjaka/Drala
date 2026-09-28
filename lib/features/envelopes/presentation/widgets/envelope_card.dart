import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_overspend_warning.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_progress.dart';
import 'package:flutter/material.dart';

class EnvelopeCard extends StatelessWidget {
  const EnvelopeCard({
    required this.envelope,
    required this.onDelete,
    this.displayCurrency,
    super.key,
  });

  final Envelope envelope;
  final VoidCallback onDelete;
  final CurrencyState? displayCurrency;

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        GestureDetector(
          onLongPress: onDelete,
          child: Container(
            key: const Key('envelope-card-surface'),
            height: 110,
            padding: const EdgeInsets.fromLTRB(19, 13, 13, 10),
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).colorScheme.onSurface),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${envelope.emoji} ${envelope.categoryName}',
                    style: TextStyle(
                        color: foreground,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrivacyText(_compact(_convert(envelope.spent)),
                        style: TextStyle(
                            color: foreground,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    PrivacyText(_compact(_convert(envelope.amount), gap: false),
                        style: TextStyle(
                            color: foreground,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 15),
                EnvelopeProgress(
                  value: envelope.progress.clamp(0, 1),
                  foregroundColor: foreground,
                ),
              ],
            ),
          ),
        ),
        if (envelope.isExceeded) ...[
          const SizedBox(height: 6),
          EnvelopeOverspendWarning(
              envelope: envelope, displayCurrency: displayCurrency),
        ],
      ],
    );
  }

  num _convert(num amount) =>
      displayCurrency?.convertToSelected(
        amount,
        envelope.currencyCode,
      ) ??
      amount;

  String _compact(num value, {bool gap = true}) {
    final separator = gap ? ' ' : '';
    if (value.abs() >= 1000000) {
      return '${_trim(value / 1000000)}${separator}M';
    }
    if (value.abs() >= 1000) return '${_trim(value / 1000)}${separator}k';
    return _trim(value);
  }

  String _trim(num value) => value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
}
