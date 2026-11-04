import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:budgets/core/ui/app_sheet_surface.dart';
import 'package:budgets/core/ui/app_sheet_header.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
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
    return await showAppSheet<bool>(
          context,
          barrierDismissible: false,
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
    return AppSheetSurface(
        height: 360,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSheetHeader(
                  title: 'Use multiple wallets?',
                  onClose: () => Navigator.pop(context, false)),
              const SizedBox(height: 10),
              PrivacyText(
                'No single wallet has enough. Drala can combine wallet balances '
                'to pay ${format.format(requiredAmount)}. Your wallets contain '
                '${format.format(availableAmount)} in total.',
                hiddenText: 'No single wallet has enough. Drala can combine '
                    'wallet balances to pay ***. Your wallets contain *** '
                    'in total.',
                style: AppTextStyle(AppTextRole.body,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.45),
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
                      backgroundColor: AppFinanceSurfaceTheme.action(context),
                      foregroundColor: AppFinanceSurfaceTheme.onAction(context),
                      text: 'Use all wallets',
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }
}
