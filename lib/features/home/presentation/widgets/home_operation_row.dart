import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:flutter/material.dart';

class HomeOperationRow extends StatelessWidget {
  const HomeOperationRow({
    required this.entry,
    required this.currencyState,
    required this.onTap,
    super.key,
  });

  final FinanceEntry entry;
  final CurrencyState? currencyState;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: entry.isTransfer ? null : onTap,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                shape: BoxShape.circle,
              ),
              child: Text(entry.emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 17 / 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      height: 14 / 10,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 18,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                color: _badgeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: PrivacyText(
                '$_sign${formatAmountWithCurrency(
                  _amount,
                  _currencyCode,
                  preserveFraction: true,
                )}',
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xFF343434),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _badgeColor {
    if (entry.isExpense) return const Color(0xFFF4B3B3);
    if (entry.isIncome) return const Color(0xFF7CE6C2);
    return const Color(0xFFE8E8E8);
  }

  String get _sign => entry.isExpense ? '-' : (entry.isIncome ? '+' : '');

  String get _currencyCode => currencyState?.code ?? entry.currencyCode;

  num get _amount =>
      currencyState?.convertToSelected(entry.amount, entry.currencyCode) ??
      entry.amount;
}
