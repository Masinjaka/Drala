import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/transactions/presentation/widgets/reference_transaction_surface.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:flutter/material.dart';
import 'wallet_selection_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_picker_scope.dart';

class WalletSelectionSheet extends StatefulWidget {
  const WalletSelectionSheet(
      {required this.wallets,
      required this.selected,
      required this.label,
      this.currencyState,
      super.key});
  final List<WalletSummary> wallets;
  final String? selected;
  final String label;
  final CurrencyState? currencyState;
  static Future<String?> show(BuildContext context,
      {required List<WalletSummary> wallets,
      required String? selected,
      required String label,
      CurrencyState? currencyState}) {
    final picker = TransactionPickerScope.of(context);
    if (picker != null) {
      return picker.open((finish) => WalletSelectionPage(
          wallets: wallets,
          selected: selected,
          label: label,
          currencyState: currencyState,
          onSelected: finish,
          onBack: () => finish(null)));
    }
    return showTransactionFormSheet<String>(context,
        builder: (_) => WalletSelectionSheet(
            wallets: wallets,
            selected: selected,
            label: label,
            currencyState: currencyState));
  }

  @override
  State<WalletSelectionSheet> createState() => _WalletSelectionSheetState();
}

class _WalletSelectionSheetState extends State<WalletSelectionSheet> {
  final _pages = PageController();
  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ReferenceTransactionSurface(
          controller: _pages,
          initialHeightFactor: .62,
          pages: [
            WalletSelectionPage(
                wallets: widget.wallets,
                selected: widget.selected,
                label: widget.label,
                currencyState: widget.currencyState,
                onBack: () => Navigator.pop(context),
                onSelected: (id) => Navigator.pop(context, id))
          ]);
}
