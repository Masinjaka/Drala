import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/transactions/domain/model/transaction_model.dart';
import 'package:budgets/widgets/skeleton/profile_picture_skeleton.dart';
import 'package:flutter/material.dart';

class TransactionListItemContent extends StatelessWidget {
  const TransactionListItemContent({
    super.key,
    required this.transaction,
    required this.currency,
    required this.borderRadius,
    required this.onTap,
  });

  final TransactionModel transaction;
  final CurrencyState? currency;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCardSurface(
      color: Theme.of(context).cardColor,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: CategoryIcon(
                  iconKey: transaction.category?.iconKey,
                  emoji: transaction.category?.emoji,
                  colorHex: transaction.category?.color),
            ),
            const SizedBox(width: 12.8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category?.name ?? 'Uncategorized',
                    style: AppTextStyle(AppTextRole.body,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.description ?? '',
                    style: AppTextStyle(AppTextRole.body,
                        color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.8),
            if (currency == null)
              textSkeleton(context, 80, 16)
            else
              Text(
                formatAmountWithCurrency(
                  convertFromMga(
                    transaction.amount,
                    currency!.rateFor(currency!.code),
                  ),
                  currency!.code,
                  preserveFraction: true,
                ),
                style: AppTextTheme.amount(
                  Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
