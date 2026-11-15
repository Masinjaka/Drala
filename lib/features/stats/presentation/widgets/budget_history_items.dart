part of 'budget_history_card.dart';

extension _BudgetHistoryItems on BudgetHistoryCard {
  Widget _buildHistoryList(
    BuildContext context,
    List<BudgetHistory> history,
    Color? textColor,
    bool isDarkMode,
    double rate,
    String currencyCode,
  ) {
    return Column(
      children: history.map((item) {
        return _buildBudgetItem(
          context,
          item,
          textColor,
          isDarkMode,
          rate,
          currencyCode,
        );
      }).toList(),
    );
  }

  Widget _buildBudgetItem(
    BuildContext context,
    BudgetHistory item,
    Color? textColor,
    bool isDarkMode,
    double rate,
    String currencyCode,
  ) {
    final progress = (item.percentageUsed.clamp(0.0, 100.0) / 100.0);
    final spent = convertFromMga(item.spentAsDouble, rate);
    final amount = convertFromMga(item.amountAsDouble, rate);

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceDim,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    child: Center(
                      child: CategoryIcon(
                          iconKey: item.category?.iconKey,
                          emoji: item.category?.emoji,
                          colorHex: item.category?.color,
                          size: 18,
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceDim),
                    ),
                  ),
                  Text(
                    item.category?.name ?? 'Catégorie inconnue',
                    style: AppTextStyle(AppTextRole.body,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                ],
              ),
              Text(
                '${formatAmountWithCurrency(spent, currencyCode, preserveFraction: true)} / ${formatAmountWithCurrency(amount, currencyCode, preserveFraction: true)}',
                style: AppTextTheme.amount(AppTextStyle(AppTextRole.body,
                    color: Theme.of(context).textTheme.bodyMedium?.color)),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildProgressBar(context, progress),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double progress) {
    Color getProgressColor() {
      if (progress > 0.9) return AppDangerTheme.criticalWarning(context);
      if (progress > 0.7) return AppDangerTheme.warning(context);
      return Theme.of(context).primaryColor;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: progress),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        builder: (context, value, _) => LinearProgressIndicator(
          value: value,
          minHeight: 8,
          backgroundColor: Theme.of(context).colorScheme.surfaceDim,
          valueColor: AlwaysStoppedAnimation<Color>(getProgressColor()),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
