import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_default_badge.dart';
import 'package:flutter/material.dart';

class WalletOverviewCard extends StatelessWidget {
  const WalletOverviewCard(
      {required this.wallet,
      required this.index,
      required this.onPressed,
      this.currencyState,
      this.selecting = false,
      this.selected = false,
      this.selectionEnabled = true,
      super.key});
  final WalletSummary wallet;
  final int index;
  final VoidCallback? onPressed;
  final CurrencyState? currencyState;
  final bool selecting;
  final bool selected;
  final bool selectionEnabled;

  @override
  Widget build(BuildContext context) => AppCardSurface(
      color: AppFinanceSurfaceTheme.field(context),
      borderRadius: AppFinanceSurfaceTheme.cardRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('wallet-card-action-${wallet.id}'),
        onTap: onPressed,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                if (selecting) ...[
                  SizedBox.square(
                    dimension: 28,
                    child: Checkbox(
                      key: Key('select-wallet-${wallet.id}'),
                      value: selected,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: selectionEnabled && onPressed != null
                          ? (_) => onPressed!()
                          : null,
                    ),
                  ),
                  const Spacer(),
                ],
                Icon(
                    switch (wallet.iconKey) {
                      'bank' => Icons.account_balance,
                      'cash' => Icons.payments,
                      'mobile' || 'mobile_money' => Icons.phone_iphone,
                      _ => Icons.account_balance_wallet,
                    },
                    size: 28,
                    color: AppIconForeground.monochrome(context)),
              ]),
              const Spacer(),
              Text(wallet.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFinanceSurfaceTheme.label(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: PrivacyText(
                      '${currencyState?.code == 'MGA' || (currencyState == null && wallet.currencyCode == 'MGA') ? 'Ar' : currencySymbolForCode(currencyState?.code ?? wallet.currencyCode)} ${formatAmountForInput(currencyState?.convertToSelected(wallet.balance, wallet.currencyCode) ?? wallet.balance, preserveFraction: true)}',
                      style: AppFinanceSurfaceTheme.value(context))),
              const SizedBox(height: 10),
              if (wallet.isDefault) const WalletDefaultBadge()
            ])),
      ));
}
