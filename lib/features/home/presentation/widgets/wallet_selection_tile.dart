import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:flutter/material.dart';
import 'localized_wallet_name.dart';

class WalletSelectionTile extends StatelessWidget {
  const WalletSelectionTile(
      {required this.wallet,
      required this.selected,
      required this.onTap,
      this.currencyState,
      super.key});
  final WalletSummary wallet;
  final bool selected;
  final VoidCallback onTap;
  final CurrencyState? currencyState;
  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? AppFinanceSurfaceTheme.onAction(context)
        : Theme.of(context).colorScheme.onSurface;
    return Semantics(
        selected: selected,
        button: true,
        child: Material(
            color: selected
                ? AppFinanceSurfaceTheme.action(context)
                : AppFinanceSurfaceTheme.background(context),
            borderRadius: AppFinanceSurfaceTheme.fieldRadius,
            child: InkWell(
                key: Key('wallet-choice-${wallet.id}'),
                onTap: onTap,
                borderRadius: AppFinanceSurfaceTheme.fieldRadius,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(children: [
                      Icon(
                          switch (wallet.iconKey) {
                            'bank' => Icons.account_balance,
                            'cash' => Icons.payments,
                            _ => Icons.account_balance_wallet
                          },
                          color: foreground,
                          size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                          flex: 3,
                          child: Text(localizedWalletName(context, wallet),
                              style: AppFinanceSurfaceTheme.label(context)
                                  .copyWith(color: foreground))),
                      const SizedBox(width: 8),
                      Flexible(
                          flex: 2,
                          child: PrivacyText(
                              formatAmountWithCurrency(
                                  currencyState?.convertToSelected(
                                          wallet.balance,
                                          wallet.currencyCode) ??
                                      wallet.balance,
                                  currencyState?.code ?? wallet.currencyCode,
                                  preserveFraction: true),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: foreground))),
                    ])))));
  }
}
