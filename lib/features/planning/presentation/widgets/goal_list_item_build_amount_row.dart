part of 'goal_list_item.dart';

extension _GoalListItemStateBuildAmountRow on _GoalListItemState {
  Widget _buildAmountRow(BuildContext context, double currentAmount,
      double goalAmount, String currencyCode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatAmountWithCurrency(
            currentAmount,
            currencyCode,
            preserveFraction: true,
          ),
          style: AppTextTheme.amount(
              AppTextStyle(AppTextRole.body, color: Colors.black)),
        ),
        Text(
          formatAmountWithCurrency(
            goalAmount,
            currencyCode,
            preserveFraction: true,
          ),
          style: AppTextTheme.amount(AppTextStyle(AppTextRole.body,
              color: Theme.of(context).textTheme.bodyMedium?.color)),
        ),
      ],
    );
  }
}
