import 'package:budgets/features/stats/presentation/widgets/stats_line_chart_painter.dart';
import 'package:flutter/material.dart';

class StatsLineChart extends StatelessWidget {
  const StatsLineChart({required this.values, super.key});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    return Column(
      children: [
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, progress, _) => CustomPaint(
              key: const Key('stats-line-chart'),
              painter: StatsLineChartPainter(
                values: values,
                progress: progress,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1', style: labelStyle),
            if (values.length > 2)
              Text('${(values.length + 1) ~/ 2}', style: labelStyle),
            if (values.length > 1) Text('${values.length}', style: labelStyle),
          ],
        ),
      ],
    );
  }
}
