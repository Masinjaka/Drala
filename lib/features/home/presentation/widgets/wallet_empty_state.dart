import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class WalletEmptyState extends StatelessWidget {
  const WalletEmptyState({required this.onAdd, super.key});
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => EmptyStatePhrase(
        title: context.l10n.emptyWallets,
        brief: true,
        illustrationAsset: 'assets/illustrations/empty_states/wallets.png',
        action:
            EmptyStateAction(label: context.l10n.addWallet, onPressed: onAdd),
      );
}
