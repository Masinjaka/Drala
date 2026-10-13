import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class WalletDefaultBadge extends StatelessWidget {
  const WalletDefaultBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      key: const Key('default-wallet-badge'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        context.l10n.defaultWalletLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.onPrimary,
            ),
      ),
    );
  }
}
