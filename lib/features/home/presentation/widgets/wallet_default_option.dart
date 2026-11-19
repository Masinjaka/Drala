import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
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
    return SwitchListTile.adaptive(
      key: const Key('wallet-default-option'),
      value: value,
      onChanged: enabled ? onChanged : null,
      title: Text(context.l10n.setDefaultWallet,
          style: AppFinanceSurfaceTheme.switchTitle(context)),
      subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(context.l10n.defaultWalletDescription,
              style: AppFinanceSurfaceTheme.switchSubtitle(context))),
      contentPadding: EdgeInsets.zero,
    );
  }
}
