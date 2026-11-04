part of 'stats_chart.dart';

extension _StatsChartLayout on _StatsChartState {
  Widget _buildContent(BuildContext context) {
    final currencyState = ref.watch(currencyControllerProvider).value;
    final currencyCode = currencyState?.code ?? 'MGA';
    final rate = currencyState?.rateFor(currencyCode) ?? 1.0;

    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    const expenseColor = AppDangerTheme.expenseSeries;
    final incomeColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey.shade500;

    final startDay = _weekStartDay(_selectedWeekIndex);
    final endDay = _weekEndDay(_selectedWeekIndex);
    final weekLength = endDay - startDay + 1;

    // Slice data to selected week
    final expenseSlice = widget.expenseData
        .sublist(startDay, endDay + 1)
        .map((v) => v * rate)
        .toList();
    final incomeSlice = widget.incomeData
        .sublist(startDay, endDay + 1)
        .map((v) => v * rate)
        .toList();

    double maxValue = 0;
    for (final v in [...expenseSlice, ...incomeSlice]) {
      if (v > maxValue) maxValue = v;
    }
    maxValue = maxValue == 0 ? 100 : maxValue * 1.2;

    List<FlSpot> toSpots(List<double> data) =>
        List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i]));

    final dropdownWeeks = _dropdownWeeks;

    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(context, textColor, dropdownWeeks),
          SizedBox(height: 8),
          Expanded(
            child: LineChart(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              LineChartData(
                minX: 0,
                maxX: (weekLength - 1).toDouble(),
                minY: 0,
                maxY: maxValue,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxValue / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: textColor?.withValues(alpha: 0.1) ??
                        Colors.grey.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final dayNumber = startDay + value.toInt() + 1;
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '$dayNumber',
                            style: AppTextStyle(AppTextRole.caption,
                                color: textColor?.withValues(alpha: 0.7)),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) =>
                        Theme.of(context).colorScheme.surface,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isExpense = spot.barIndex == 0;
                        return LineTooltipItem(
                          formatAmountWithCurrency(spot.y, currencyCode),
                          AppTextTheme.amount(AppTextStyle(AppTextRole.body,
                              color: isExpense ? expenseColor : incomeColor)),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: toSpots(expenseSlice),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: expenseColor,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          expenseColor.withValues(alpha: 0.35),
                          expenseColor.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: toSpots(incomeSlice),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: incomeColor,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          incomeColor.withValues(alpha: 0.2),
                          incomeColor.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
