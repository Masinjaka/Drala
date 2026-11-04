import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class WalletSelectionToolbar extends StatelessWidget {
  const WalletSelectionToolbar({
    required this.value,
    required this.count,
    required this.onToggleAll,
    super.key,
  });

  final bool? value;
  final int count;
  final VoidCallback? onToggleAll;

  @override
  Widget build(BuildContext context) => Row(children: [
        Tooltip(
          message: MaterialLocalizations.of(context).selectAllButtonLabel,
          excludeFromSemantics: true,
          child: Semantics(
            label: MaterialLocalizations.of(context).selectAllButtonLabel,
            child: Checkbox(
              key: const Key('select-all-wallets'),
              tristate: true,
              value: value,
              onChanged: onToggleAll == null ? null : (_) => onToggleAll!(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(context.l10n.selectedItemCount(count),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall),
        ),
      ]);
}
