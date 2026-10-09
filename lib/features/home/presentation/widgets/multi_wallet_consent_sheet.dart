import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MultiWalletConsentSheet extends StatelessWidget {
  const MultiWalletConsentSheet({
    required this.requiredAmount,
    required this.availableAmount,
    super.key,
  });

  final int requiredAmount;
  final int availableAmount;

  static Future<bool> show(
    BuildContext context, {
    required int requiredAmount,
    required int availableAmount,
  }) async {
    return await showModalBottomSheet<bool>(
          context: context,
          useSafeArea: true,
          showDragHandle: true,
          isDismissible: false,
          enableDrag: false,
          backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
          builder: (_) => MultiWalletConsentSheet(
            requiredAmount: requiredAmount,
            availableAmount: availableAmount,
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.decimalPattern('fr_FR');
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Use multiple wallets?',
            style: TextStyle(
              fontSize: AppTypography.title,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          PrivacyText(
            'No single wallet has enough. Drala can combine wallet balances '
            'to pay ${format.format(requiredAmount)}. Your wallets contain '
            '${format.format(availableAmount)} in total.',
            hiddenText: 'No single wallet has enough. Drala can combine '
                'wallet balances to pay ***. Your wallets contain *** '
                'in total.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: AppTypography.body,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: CustomButton.outlined(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Use all wallets',
                  onPressed: () => Navigator.pop(context, true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
