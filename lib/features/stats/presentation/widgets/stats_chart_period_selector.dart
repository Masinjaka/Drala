part of 'stats_chart.dart';

extension _StatsChartPeriodSelector on _StatsChartState {
  Widget _buildPeriodSelector(
          BuildContext context, Color? textColor, List<int> dropdownWeeks) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Évolution',
            style: AppTextStyle(AppTextRole.body,
                color: textColor?.withValues(alpha: 0.7)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4.8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: textColor?.withValues(alpha: 0.08) ??
                    Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedWeekIndex,
                isDense: true,
                style: AppTextStyle(AppTextRole.input,
                    color: textColor?.withValues(alpha: 0.8)),
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppIconForeground.resolve(
                      context, textColor?.withValues(alpha: 0.5)),
                ),
                items: dropdownWeeks
                    .map(
                      (w) => DropdownMenuItem(
                        value: w,
                        child: Text(_weekLabel(w)),
                      ),
                    )
                    .toList(),
                onChanged: (w) {
                  if (w != null) _update(() => _selectedWeekIndex = w);
                },
              ),
            ),
          ),
        ],
      );
}
