part of 'budget_history_card.dart';

extension _BudgetHistoryStates on BudgetHistoryCard {
  Widget _buildEmptyState(BuildContext context, Color? textColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 24,
              color: AppIconForeground.resolve(
                  context, textColor?.withValues(alpha: 0.3)),
            ),
            SizedBox(height: 8),
            Text(
              'Aucun budget enregistré pour ce mois',
              style: AppTextStyle(AppTextRole.body,
                  color: textColor?.withValues(alpha: 0.5)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Color? textColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'Erreur lors du chargement',
          style: AppTextStyle(AppTextRole.body,
              color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context, bool isDarkMode) {
    final baseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    final highlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
