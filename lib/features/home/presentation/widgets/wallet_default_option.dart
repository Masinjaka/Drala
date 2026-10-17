import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class WalletDefaultOption extends StatelessWidget {
  const WalletDefaultOption({
    required this.value,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(10),
      child: SwitchListTile.adaptive(
        key: const Key('wallet-default-option'),
        value: value,
        onChanged: enabled ? onChanged : null,
        title: Text(context.l10n.setDefaultWallet,
            style: theme.textTheme.bodyMedium),
        subtitle: Text(context.l10n.defaultWalletDescription,
            style: theme.textTheme.bodySmall),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
