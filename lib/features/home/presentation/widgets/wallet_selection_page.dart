import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/app_close_button.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'localized_wallet_name.dart';
import 'wallet_selection_tile.dart';

class WalletSelectionPage extends StatefulWidget {
  const WalletSelectionPage(
      {required this.wallets,
      required this.selected,
      required this.label,
      required this.onSelected,
      required this.onBack,
      this.currencyState,
      super.key});
  final List<WalletSummary> wallets;
  final String? selected;
  final String label;
  final CurrencyState? currencyState;
  final ValueChanged<String?> onSelected;
  final VoidCallback onBack;
  @override
  State<WalletSelectionPage> createState() => _WalletSelectionPageState();
}

class _WalletSelectionPageState extends State<WalletSelectionPage> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final wallets = widget.wallets
        .where((wallet) =>
            wallet.name.toLowerCase().contains(query) ||
            localizedWalletName(context, wallet).toLowerCase().contains(query))
        .toList(growable: false);
    return Semantics(
        label: widget.label,
        scopesRoute: true,
        explicitChildNodes: true,
        child: Material(
            color: AppFinanceSurfaceTheme.background(context),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 16),
                child: Column(children: [
                  Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: AppCloseButton(
                          key: const Key('wallet-picker-close'),
                          onPressed: widget.onBack)),
                  const SizedBox(height: 24),
                  TextField(
                      key: const Key('wallet-search'),
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      style: AppFinanceSurfaceTheme.label(context),
                      decoration: AppFinanceSurfaceTheme.input(context,
                          hint: context.l10n.wallets,
                          prefix: const Icon(Icons.search, size: 20))),
                  const SizedBox(height: 24),
                  Expanded(
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: wallets.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) => WalletSelectionTile(
                              wallet: wallets[index],
                              selected: wallets[index].id == widget.selected,
                              currencyState: widget.currencyState,
                              onTap: () =>
                                  widget.onSelected(wallets[index].id)))),
                ]))));
  }
}
