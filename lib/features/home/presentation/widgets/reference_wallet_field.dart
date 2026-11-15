import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/forms/validated_selection.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:flutter/material.dart';
import 'localized_wallet_name.dart';
import 'wallet_selection_sheet.dart';

class ReferenceWalletField extends StatelessWidget {
  const ReferenceWalletField(
      {required this.label,
      required this.wallets,
      required this.value,
      required this.onChanged,
      required this.requiredSelection,
      this.currencyState,
      this.fieldKey,
      this.emptyLabel,
      super.key});
  final String label;
  final List<WalletSummary> wallets;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final Key? fieldKey;
  final String? emptyLabel;
  final bool requiredSelection;
  final CurrencyState? currencyState;
  @override
  Widget build(BuildContext context) {
    final wallet = wallets.where((wallet) => wallet.id == value).firstOrNull;
    return ValidatedSelection(
        value: wallet?.id,
        validator: () => requiredSelection
            ? FieldValidators.required(context, wallet?.id)
            : null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppFinanceSurfaceTheme.label(context)),
          const SizedBox(height: 10),
          Material(
              color: AppFinanceSurfaceTheme.field(context),
              shape: RoundedRectangleBorder(
                  borderRadius: AppFinanceSurfaceTheme.fieldRadius,
                  side: BorderSide(
                      color: AppFinanceSurfaceTheme.border(context))),
              child: InkWell(
                  key: fieldKey ?? Key('wallet-field-$label'),
                  borderRadius: AppFinanceSurfaceTheme.fieldRadius,
                  onTap: onChanged == null
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final selected = await WalletSelectionSheet.show(
                              context,
                              wallets: wallets,
                              selected: value,
                              label: label,
                              currencyState: currencyState);
                          if (context.mounted && selected != null) {
                            onChanged?.call(selected);
                          }
                        },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(children: [
                        Expanded(
                            child: Text(
                                wallet == null
                                    ? emptyLabel ?? label
                                    : localizedWalletName(context, wallet),
                                style: AppFinanceSurfaceTheme.label(context))),
                        const SizedBox(width: 8),
                        Icon(
                            switch (wallet?.iconKey) {
                              'bank' => Icons.account_balance,
                              'cash' => Icons.payments,
                              'mobile' || 'mobile_money' => Icons.phone_iphone,
                              _ => Icons.account_balance_wallet,
                            },
                            size: 20)
                      ])))),
        ]));
  }
}
