import 'package:budgets/core/forms/submit_validated_form.dart';
import 'package:budgets/core/forms/submission_validation_scope.dart';
import 'package:budgets/core/currency/currency_amount_input.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/transfer_wallet_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_reference_layout.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class ManualTransferFormPage extends StatelessWidget {
  const ManualTransferFormPage(
      {required this.formKey,
      required this.wallets,
      required this.amount,
      required this.description,
      required this.fromWalletId,
      required this.toWalletId,
      required this.onFromChanged,
      required this.onToChanged,
      required this.onSave,
      this.currencyState,
      super.key});
  final GlobalKey<FormState> formKey;
  final List<WalletSummary> wallets;
  final TextEditingController amount;
  final TextEditingController description;
  final String? fromWalletId;
  final String? toWalletId;
  final ValueChanged<String?> onFromChanged;
  final ValueChanged<String?> onToChanged;
  final VoidCallback onSave;
  final CurrencyState? currencyState;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: amount,
        builder: (context, _) {
          final source = wallets.where((w) => w.id == fromWalletId).firstOrNull;
          final destination =
              wallets.where((w) => w.id == toWalletId).firstOrNull;
          final value = CurrencyAmountInput.toMga(amount.text, currencyState);
          final compatible = source?.currencyCode == 'MGA' &&
              destination?.currencyCode == 'MGA';
          final enough = source != null && value <= source.balance;
          final error = wallets.length < 2
              ? context.l10n.transferNeedsWallets
              : !enough && value > 0
                  ? context.l10n.insufficientWalletFunds
                  : source != null && destination != null && !compatible
                      ? context.l10n.walletCurrencyMismatch
                      : null;
          return SubmitValidatedForm(
              formKey: formKey,
              child: TransactionReferenceLayout(
                  actions: TransactionFormActions(
                      saving: false,
                      onSave: onSave,
                      saveKey: const Key('save-manual-transfer')),
                  children: [
                    const SizedBox(height: 28),
                    TransactionAmountField(
                        controller: amount,
                        currencyCode: currencyState?.code ?? 'MGA'),
                    const SizedBox(height: 48),
                    TransferWalletField(
                        key: const Key('transfer-from-wallet'),
                        label: context.l10n.fromWallet,
                        wallets: wallets,
                        value: fromWalletId,
                        onChanged: onFromChanged,
                        currencyState: currencyState),
                    const SizedBox(height: 24),
                    TransferWalletField(
                        key: const Key('transfer-to-wallet'),
                        label: context.l10n.toWallet,
                        wallets: wallets
                            .where((w) => w.id != fromWalletId)
                            .toList(growable: false),
                        value: toWalletId,
                        onChanged: onToChanged,
                        currencyState: currencyState),
                    if (error != null)
                      Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Builder(
                              builder: (context) =>
                                  SubmissionValidationScope.of(context)
                                              ?.submitted !=
                                          true
                                      ? const SizedBox.shrink()
                                      : Text(error,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error)))),
                  ]));
        },
      );
}
