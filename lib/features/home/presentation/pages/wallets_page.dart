import 'package:budgets/core/widgets/delayed_skeleton.dart';
import 'package:budgets/core/layout/app_scroll_padding.dart';
import 'package:budgets/core/ui/app_scroll_under_header.dart';
import 'package:budgets/core/ui/app_bottom_action.dart';
import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_selection_toolbar.dart';
import 'package:budgets/core/ui/detail_enter_transition.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_page_header.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_empty_state.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/domain/models/wallet_editor_result.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/add_wallet_sheet.dart';
import 'package:budgets/features/home/presentation/widgets/edit_wallet_sheet.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_overview_card.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_card_skeleton.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';

part 'wallets_page_actions.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({
    required this.wallets,
    required this.onAddWallet,
    required this.onUpdateWallet,
    required this.onDeleteWallet,
    this.currencyState,
    this.onDeleteWallets,
    this.walletsListenable,
    this.walletReader,
    this.loadingReader,
    super.key,
  });

  final List<WalletSummary> wallets;
  final Future<void> Function(AddWalletInput) onAddWallet;
  final Future<void> Function(String, AddWalletInput) onUpdateWallet;
  final Future<void> Function(String) onDeleteWallet;
  final CurrencyState? currencyState;
  final Future<void> Function(List<String>)? onDeleteWallets;
  final Listenable? walletsListenable;
  final List<WalletSummary> Function()? walletReader;
  final bool Function()? loadingReader;

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  bool _selecting = false;
  bool _deleting = false;
  final Set<String> _selected = {};
  void _update(VoidCallback change) => setState(change);
  @override
  Widget build(BuildContext context) => widget.walletsListenable == null
      ? _buildPage(context)
      : ListenableBuilder(
          listenable: widget.walletsListenable!,
          builder: (context, _) => _buildPage(context));

  Widget _buildPage(BuildContext context) {
    final selectable = _selectableWalletIds;
    final selected = _selected.intersection(selectable);
    return Scaffold(
      backgroundColor: AppFinanceSurfaceTheme.background(context),
      extendBody: true,
      bottomNavigationBar: AppBottomAction(
          buttonKey: Key(_selecting ? 'cancel-selection' : 'wallet-create'),
          label: _selecting ? context.l10n.cancel : context.l10n.addWallet,
          onPressed: _deleting
              ? null
              : _selecting
                  ? _cancelSelection
                  : () => _add(context)),
      body: AppScrollUnderHeader(
        header: Padding(
          padding: const EdgeInsets.only(top: AppHeaderMetrics.topPadding),
          child: Column(children: [
            Padding(
              padding: AppPageSpacing.insets(context),
              child: WalletPageHeader(
                  selecting: _selecting,
                  busy: _deleting,
                  onDelete:
                      _deleting || selected.isEmpty ? null : _deleteSelected,
                  onSelect: widget.onDeleteWallets != null && !_selecting
                      ? () => _update(() => _selecting = true)
                      : null),
            ),
            if (widget.onDeleteWallets != null && _selecting)
              Padding(
                  padding: AppPageSpacing.insets(context),
                  child: WalletSelectionToolbar(
                      value: selected.isEmpty
                          ? false
                          : selected.length == selectable.length
                              ? true
                              : null,
                      count: selected.length,
                      onToggleAll: _deleting || selectable.isEmpty
                          ? null
                          : _toggleAllWallets)),
            const SizedBox(height: 19),
          ]),
        ),
        child: Builder(builder: _cards),
      ),
    );
  }

  Widget _cards(BuildContext context) {
    final currentWallets = widget.walletReader?.call() ?? widget.wallets;
    if (widget.loadingReader?.call() == true && currentWallets.isEmpty) {
      return DelayedSkeleton(
        pending: true,
        builder: (context, show) => show
            ? ListView.separated(
                padding: AppScrollPadding.insets(context, top: 0, bottom: 32),
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, __) => const WalletCardSkeleton(),
              )
            : const SizedBox.shrink(),
      );
    }
    if (currentWallets.isEmpty) {
      return const WalletEmptyState();
    }
    return LayoutBuilder(
        builder: (context, constraints) => GridView.builder(
              padding: AppScrollPadding.insets(context, top: 0, bottom: 32),
              itemCount: currentWallets.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (constraints.maxWidth / 240).floor().clamp(2, 4),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 180 +
                      (MediaQuery.textScalerOf(context).scale(12) - 12)
                              .clamp(0.0, 48.0) *
                          5),
              itemBuilder: (context, index) => DetailEnterTransition(
                  child: WalletOverviewCard(
                selecting: _selecting,
                selected: _selected.contains(currentWallets[index].id),
                selectionEnabled:
                    !_deleting && !currentWallets[index].isDefault,
                wallet: currentWallets[index],
                index: index,
                currencyState: widget.currencyState,
                onPressed: _deleting
                    ? null
                    : () => _selecting
                        ? _toggleWallet(currentWallets[index])
                        : _edit(context, currentWallets[index]),
              )),
            ));
  }
}
