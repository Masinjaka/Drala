import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/controllers/home_entry_actions.dart';
import 'package:budgets/features/home/presentation/widgets/chat_input_bar.dart';
import 'package:flutter/material.dart';

class HomeActivityComposer extends StatelessWidget {
  const HomeActivityComposer(
      {required this.viewModel,
      required this.onFinanceChanged,
      this.currency,
      super.key});
  final AiEntryViewModel viewModel;
  final Future<void> Function() onFinanceChanged;
  final CurrencyState? currency;

  Future<bool> _refreshAfter(Future<bool> Function() action) async {
    final succeeded = await action();
    if (succeeded) await onFinanceChanged();
    return succeeded;
  }

  @override
  Widget build(BuildContext context) {
    final actions = HomeEntryActions(viewModel, currencyState: currency);
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => ChatInputBar(
              embedded: true,
              isSubmitting: viewModel.isSubmitting,
              currencyCode: currency?.code ?? viewModel.walletCurrencyCode,
              isQuotaExhausted: !viewModel.hasUnlimitedAiRequests &&
                  viewModel.remainingRequests == 0,
              onSubmit: (message) =>
                  _refreshAfter(() => actions.submitMessage(context, message)),
              onReceiptSubmit: (input) =>
                  _refreshAfter(() => actions.submitReceipt(context, input)),
              onManualEntryRequested: () async {
                await actions.addManual(context);
                await onFinanceChanged();
              },
            ));
  }
}
