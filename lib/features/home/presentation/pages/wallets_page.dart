import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/detail_page_header.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/domain/models/wallet_editor_result.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/add_wallet_sheet.dart';
import 'package:budgets/features/home/presentation/widgets/edit_wallet_sheet.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_overview_card.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({
    required this.wallets,
    required this.onAddWallet,
    required this.onUpdateWallet,
    required this.onDeleteWallet,
    this.currencyState,
    this.walletsListenable,
    this.walletReader,
    super.key,
  });

  final List<WalletSummary> wallets;
  final Future<void> Function(AddWalletInput) onAddWallet;
  final Future<void> Function(String, AddWalletInput) onUpdateWallet;
  final Future<void> Function(String) onDeleteWallet;
  final CurrencyState? currencyState;
  final Listenable? walletsListenable;
  final List<WalletSummary> Function()? walletReader;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: DetailPageHeader(
                  title: context.l10n.wallets,
                  onAdd: () => _add(context),
                  addTooltip: context.l10n.addWallet,
                ),
              ),
              const SizedBox(height: 19),
              Expanded(child: _walletList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _walletList() {
    final listenable = walletsListenable;
    if (listenable == null) return _cards();
    return ListenableBuilder(
        listenable: listenable, builder: (_, __) => _cards());
  }

  Widget _cards() {
    final currentWallets = walletReader?.call() ?? wallets;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(29, 0, 29, 32),
      itemCount: currentWallets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => WalletOverviewCard(
        wallet: currentWallets[index],
        index: index,
        currencyState: currencyState,
        onPressed: () => _edit(context, currentWallets[index]),
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final input =
        await AddWalletSheet.show(context, currencyState: currencyState);
    if (input == null || !context.mounted) return;
    try {
      await onAddWallet(input);
    } catch (error) {
      if (context.mounted) showErrorToast(context, error);
    }
  }

  Future<void> _edit(BuildContext context, WalletSummary wallet) async {
    final result = await EditWalletSheet.show(context,
        wallet: wallet, currencyState: currencyState);
    if (result == null || !context.mounted) return;
    try {
      if (result.action == WalletEditorAction.delete) {
        await onDeleteWallet(wallet.id);
      } else {
        await onUpdateWallet(wallet.id, result.input!);
      }
    } catch (error) {
      if (context.mounted) showErrorToast(context, error);
    }
  }
}
