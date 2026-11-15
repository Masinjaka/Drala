import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/core/ui/app_empty_state_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class WalletEmptyState extends StatelessWidget {
  const WalletEmptyState({super.key});
  @override
  Widget build(BuildContext context) => EmptyStatePhrase(
        title: context.l10n.emptyWallets,
        brief: true,
        illustrationAsset: 'assets/illustrations/empty_states/wallets.png',
        titleStyle: AppEmptyStateTheme.supportingMessage(context),
      );
}
