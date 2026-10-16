import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_sheet_header.dart';
import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:budgets/core/ui/app_sheet_surface.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_source_option.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WalletSourceSheet extends StatefulWidget {
  const WalletSourceSheet({
    required this.wallets,
    required this.requiredAmount,
    this.title,
    this.message,
    this.currencyState,
    super.key,
  });

  final List<WalletSummary> wallets;
  final int requiredAmount;
  final String? title;
  final String? message;
  final CurrencyState? currencyState;

  static Future<String?> show(
    BuildContext context, {
    required List<WalletSummary> wallets,
    required int requiredAmount,
    String? title,
    String? message,
    CurrencyState? currencyState,
  }) {
    return showAppSheet<String>(
      context,
      builder: (_) => WalletSourceSheet(
        wallets: wallets,
        requiredAmount: requiredAmount,
        title: title,
        message: message,
        currencyState: currencyState,
      ),
    );
  }

  @override
  State<WalletSourceSheet> createState() => _WalletSourceSheetState();
}

class _WalletSourceSheetState extends State<WalletSourceSheet> {
  String? _selectedWalletId;

  @override
  void initState() {
    super.initState();
    final eligible = widget.wallets.where(_isEligible);
    _selectedWalletId =
        eligible.where((wallet) => wallet.isDefault).firstOrNull?.id ??
            eligible.firstOrNull?.id;
  }

  bool _isEligible(WalletSummary wallet) =>
      wallet.balance >= widget.requiredAmount;

  @override
  Widget build(BuildContext context) {
    final sourceCode = widget.wallets
            .where((wallet) => wallet.isDefault)
            .firstOrNull
            ?.currencyCode ??
        (widget.wallets.isEmpty ? 'MGA' : widget.wallets.first.currencyCode);
    final displayCode = widget.currencyState?.code ?? sourceCode;
    final displayRequired = widget.currencyState?.convertToSelected(
          widget.requiredAmount,
          sourceCode,
        ) ??
        widget.requiredAmount;

    return AppSheetSurface(
      heightFactor: .59,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSheetHeader(
              title: widget.title ?? context.l10n.walletSourceChooseAnother,
              onClose: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
            PrivacyText(
              widget.message ??
                  context.l10n.walletSourceAmountNeeded(
                    formatAmountWithCurrency(
                      displayRequired,
                      displayCode,
                      preserveFraction: true,
                    ),
                  ),
              hiddenText: widget.message ??
                  context.l10n.walletSourceAmountNeeded('***'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: widget.wallets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final wallet = widget.wallets[index];
                  return WalletSourceOption(
                    wallet: wallet,
                    enabled: _isEligible(wallet),
                    selected: wallet.id == _selectedWalletId,
                    balanceText: _balanceText(wallet),
                    onTap: () => setState(() => _selectedWalletId = wallet.id),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            CustomButton(
              key: const Key('confirm-wallet-source'),
              text: widget.requiredAmount > 0
                  ? context.l10n.walletSourceUseWallet
                  : context.l10n.walletSourceSaveWallet,
              height: 40,
              borderRadius: BorderRadius.circular(6),
              onPressed: _selectedWalletId == null
                  ? null
                  : () => Navigator.pop(context, _selectedWalletId),
            ),
          ],
        ),
      ),
    );
  }

  String _balanceText(WalletSummary wallet) {
    final converted = widget.currencyState?.convertToSelected(
          wallet.balance,
          wallet.currencyCode,
        ) ??
        wallet.balance;
    return formatAmountWithCurrency(
      converted,
      widget.currencyState?.code ?? wallet.currencyCode,
      preserveFraction: true,
    );
  }
}
