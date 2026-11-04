import 'reference_wallet_field.dart';
import 'package:budgets/core/forms/submission_validation_scope.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/localized_wallet_name.dart';
import 'package:flutter/material.dart';

class TransferWalletField extends StatelessWidget {
  const TransferWalletField(
      {required this.label,
      required this.wallets,
      required this.value,
      required this.onChanged,
      this.currencyState,
      this.requiredSelection = true,
      super.key});
  final String label;
  final List<WalletSummary> wallets;
  final String? value;
  final ValueChanged<String?> onChanged;
  final CurrencyState? currencyState;
  final bool requiredSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reference = FinanceSheetScope.of(context);
    if (reference)
      return ReferenceWalletField(
          label: label,
          wallets: wallets,
          value: value,
          onChanged: onChanged,
          requiredSelection: requiredSelection,
          currencyState: currencyState);
    final field = DropdownButtonFormField<String>(
      initialValue: value,
      validator: (value) =>
          requiredSelection ? FieldValidators.required(context, value) : null,
      autovalidateMode: SubmissionValidationScope.mode(context),
      isExpanded: true,
      style: theme.textTheme.bodySmall,
      decoration: reference
          ? AppFinanceSurfaceTheme.input(context)
          : InputDecoration(
              labelText: label,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainer,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none)),
      items: wallets
          .map((wallet) => DropdownMenuItem(
                value: wallet.id,
                child: Row(children: [
                  Expanded(
                      child: Text(localizedWalletName(context, wallet),
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  PrivacyText(
                      formatAmountWithCurrency(
                          currencyState?.convertToSelected(
                                  wallet.balance, wallet.currencyCode) ??
                              wallet.balance,
                          currencyState?.code ?? wallet.currencyCode,
                          preserveFraction: true),
                      style: theme.textTheme.bodySmall),
                ]),
              ))
          .toList(growable: false),
      onChanged: wallets.isEmpty ? null : onChanged,
    );
    return !reference
        ? field
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: AppFinanceSurfaceTheme.label(context)),
            const SizedBox(height: 10),
            field
          ]);
  }
}
