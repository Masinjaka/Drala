import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/home/presentation/widgets/reference_wallet_field.dart';

class EnvelopeWalletField extends StatefulWidget {
  const EnvelopeWalletField(
      {required this.wallets,
      this.onChanged,
      this.initialWalletId,
      this.readOnly = false,
      this.currencyState,
      super.key});
  final List<WalletSummary> wallets;
  final ValueChanged<String?>? onChanged;
  final String? initialWalletId;
  final bool readOnly;
  final CurrencyState? currencyState;

  @override
  State<EnvelopeWalletField> createState() => _EnvelopeWalletFieldState();
}

class _EnvelopeWalletFieldState extends State<EnvelopeWalletField> {
  String? _selected;
  @override
  void initState() {
    super.initState();
    final requested = widget.initialWalletId ??
        (widget.readOnly
            ? null
            : widget.wallets.where((w) => w.isDefault).firstOrNull?.id ??
                widget.wallets.firstOrNull?.id);
    _selected = widget.wallets.any((wallet) => wallet.id == requested)
        ? requested
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReferenceWalletField(
            fieldKey: const Key('envelope-funding-wallet'),
            label: context.l10n.wallets,
            emptyLabel: context.l10n.envelopeFundingWalletUnavailable,
            wallets: widget.wallets,
            value: _selected,
            requiredSelection: false,
            currencyState: widget.currencyState,
            onChanged: widget.readOnly || widget.wallets.isEmpty
                ? null
                : (value) {
                    setState(() => _selected = value);
                    widget.onChanged?.call(value);
                  },
          ),
          if (widget.readOnly) ...[
            const SizedBox(height: 8),
            Text(context.l10n.envelopeFundingWalletFixed,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
