import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:flutter/material.dart';

class WalletOverviewCard extends StatelessWidget {
  const WalletOverviewCard({
    required this.wallet,
    required this.index,
    required this.onPressed,
    this.currencyState,
    super.key,
  });

  final WalletSummary wallet;
  final int index;
  final VoidCallback onPressed;
  final CurrencyState? currencyState;

  static const _backgrounds = [
    Color(0xFFF4A9AA),
    Color(0xFF7DABEB),
    Color(0xFFFFF7AA),
  ];
  static const _foregrounds = [
    Color(0xFF9D4245),
    Color(0xFF31598E),
    Color(0xFF8A7B16),
  ];

  @override
  Widget build(BuildContext context) {
    final foreground = _foregrounds[index % _foregrounds.length];
    return InkWell(
      key: Key('wallet-card-action-${wallet.id}'),
      borderRadius: BorderRadius.circular(20),
      onTap: onPressed,
      child: Container(
        height: 132,
        padding: const EdgeInsets.fromLTRB(19, 13, 14, 16),
        decoration: BoxDecoration(
          color: _backgrounds[index % _backgrounds.length],
          border: Border.all(color: Theme.of(context).colorScheme.onSurface),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(wallet.name,
                      style: TextStyle(
                          color: foreground,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ),
                Icon(Icons.more_vert_rounded, color: foreground, size: 19),
              ],
            ),
            const Spacer(),
            PrivacyText(
              _amount,
              style: TextStyle(
                  color: foreground, fontSize: 32, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  String get _amount {
    final value = currencyState?.convertToSelected(
          wallet.balance,
          wallet.currencyCode,
        ) ??
        wallet.balance;
    if (value.abs() >= 1000000) return '${_trim(value / 1000000)} M';
    if (value.abs() >= 1000) return '${_trim(value / 1000)} k';
    return _trim(value);
  }

  String _trim(num value) => value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
}
