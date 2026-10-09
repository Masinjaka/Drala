import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:flutter/material.dart';

class WalletOverviewCard extends StatelessWidget {
  const WalletOverviewCard({
    required this.wallet,
    required this.index,
    required this.onPressed,
    this.currencyState,
    super.key,
  });

  final WalletSummary wallet;
  final int index;
  final VoidCallback onPressed;
  final CurrencyState? currencyState;

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onSurface;
    return Material(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          key: Key('wallet-card-action-${wallet.id}'),
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Ink(
            height: 132,
            padding: const EdgeInsets.fromLTRB(19, 13, 14, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(wallet.name,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    Icon(Icons.more_vert_rounded, color: foreground, size: 19),
                  ],
                ),
                const Spacer(),
                PrivacyText(
                  _amount,
                  suffix: ' ${currencyState?.code ?? wallet.currencyCode}',
                  suffixStyle: AppTextTheme.currencyLabel(context),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ));
  }

  String get _amount {
    final value = currencyState?.convertToSelected(
          wallet.balance,
          wallet.currencyCode,
        ) ??
        wallet.balance;
    final amount = value.abs() >= 1000000
        ? '${_trim(value / 1000000)} M'
        : value.abs() >= 1000
            ? '${_trim(value / 1000)} k'
            : _trim(value);
    return amount;
  }

  String _trim(num value) => value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
}
