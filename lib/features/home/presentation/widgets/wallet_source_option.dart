import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:flutter/material.dart';

class WalletSourceOption extends StatelessWidget {
  const WalletSourceOption({
    required this.wallet,
    required this.balanceText,
    required this.enabled,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final WalletSummary wallet;
  final String balanceText;
  final bool enabled;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Opacity(
      opacity: enabled ? 1 : .48,
      child: Material(
        color: selected
            ? colors.inverseSurface.withValues(alpha: .08)
            : colors.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          key: Key('wallet-source-${wallet.id}'),
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(minHeight: 68),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? colors.inverseSurface : colors.outline,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    wallet.iconKey == 'bank'
                        ? Icons.account_balance_outlined
                        : Icons.account_balance_wallet_outlined,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wallet.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (wallet.isDefault || !enabled) ...[
                        const SizedBox(height: 2),
                        Text(
                          enabled ? 'Default wallet' : 'Insufficient balance',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                PrivacyText(
                  balanceText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 20,
                  color: selected ? colors.inverseSurface : colors.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
