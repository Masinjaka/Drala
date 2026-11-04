part of 'new_category_breakdown.dart';

extension _NewCategoryBreakdownLayout on _NewCategoryBreakdownState {
  Widget _buildContent(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final tabIndicatorColor = Theme.of(context).tabBarTheme.indicatorColor;
    final tabLabelColor = Theme.of(context).tabBarTheme.labelColor;
    final tabUnselectedColor = Theme.of(context)
        .tabBarTheme
        .unselectedLabelColor
        ?.withValues(alpha: 0.7);

    final currentData =
        _showExpenses ? widget.expensesByCategory : widget.incomeByCategory;
    final total = currentData.values.fold(0.0, (sum, amount) => sum + amount);
    final sortedEntries = currentData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Catégories',
            style: AppTextStyle(AppTextRole.body,
                color: textColor?.withValues(alpha: 0.7)),
          ),
          SizedBox(height: 12),
          // Tabs
          Container(
            width: 360,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _switchTab(true),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6.4),
                      decoration: BoxDecoration(
                        color: _showExpenses
                            ? tabIndicatorColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          'Dépenses',
                          style: AppTextStyle(AppTextRole.body,
                              color: _showExpenses
                                  ? tabLabelColor
                                  : tabUnselectedColor),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _switchTab(false),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6.4),
                      decoration: BoxDecoration(
                        color: !_showExpenses
                            ? tabIndicatorColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          'Revenus',
                          style: AppTextStyle(AppTextRole.body,
                              color: !_showExpenses
                                  ? tabLabelColor
                                  : tabUnselectedColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Donut chart + legend labels below
          if (sortedEntries.isEmpty)
            SizedBox(
              height: 160,
              child: Center(
                child: Text(
                  _showExpenses
                      ? 'Aucune dépense ce mois'
                      : 'Aucun revenu ce mois',
                  style: AppTextStyle(AppTextRole.body,
                      color: textColor?.withValues(alpha: 0.5)),
                ),
              ),
            )
          else ...[
            SizedBox(
              height: 144,
              child: _buildDonut(
                entries: sortedEntries,
                surfaceColor: surfaceColor,
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: sortedEntries.map((entry) {
                  final percentage =
                      total > 0 ? (entry.value / total * 100) : 0.0;
                  final baseColor = _parseColor(
                      widget.categoryColors[entry.key] ?? '#10B981');
                  final color = _applyMochaAccent(baseColor, entry.key);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '${entry.key} - ${percentage.toStringAsFixed(2)}%',
                        style: AppTextStyle(AppTextRole.body,
                            color: textColor?.withValues(alpha: 0.8)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
