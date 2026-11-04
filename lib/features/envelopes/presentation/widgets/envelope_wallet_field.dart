import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/features/home/presentation/widgets/localized_wallet_name.dart';

class EnvelopeWalletField extends StatefulWidget {
  const EnvelopeWalletField(
      {required this.wallets,
      this.onChanged,
      this.initialWalletId,
      this.readOnly = false,
      super.key});
  final List<WalletSummary> wallets;
  final ValueChanged<String?>? onChanged;
  final String? initialWalletId;
  final bool readOnly;

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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        key: const Key('envelope-funding-wallet'),
        initialValue: _selected,
        isExpanded: true,
        disabledHint: _selected == null
            ? Text(context.l10n.envelopeFundingWalletUnavailable)
            : null,
        style: theme.textTheme.bodySmall,
        decoration: InputDecoration(
          labelText: context.l10n.wallets,
          helperText:
              widget.readOnly ? context.l10n.envelopeFundingWalletFixed : null,
          helperMaxLines: 3,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainer,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
        items: widget.wallets
            .map((wallet) => DropdownMenuItem(
                  value: wallet.id,
                  child: Text(localizedWalletName(context, wallet),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ))
            .toList(growable: false),
        onChanged: widget.readOnly
            ? null
            : (value) {
                setState(() => _selected = value);
                widget.onChanged?.call(value);
              },
      ),
    );
  }
}
