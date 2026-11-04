import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'new_category_breakdown_layout.dart';

class NewCategoryBreakdown extends ConsumerStatefulWidget {
  final Map<String, double> expensesByCategory;
  final Map<String, double> incomeByCategory;
  final Map<String, String> categoryColors;
  final Map<String, String> categoryEmojis;

  const NewCategoryBreakdown({
    super.key,
    required this.expensesByCategory,
    required this.incomeByCategory,
    required this.categoryColors,
    required this.categoryEmojis,
  });

  @override
  ConsumerState<NewCategoryBreakdown> createState() =>
      _NewCategoryBreakdownState();
}

class _NewCategoryBreakdownState extends ConsumerState<NewCategoryBreakdown> {
  bool _showExpenses = true;

  void _switchTab(bool showExpenses) {
    if (_showExpenses == showExpenses) return;
    setState(() => _showExpenses = showExpenses);
  }

  @override
  Widget build(BuildContext context) => _buildContent(context);

  Widget _buildDonut({
    required List<MapEntry<String, double>> entries,
    required Color surfaceColor,
  }) {
    final radius = 28.0;
    final sections = entries.map((entry) {
      final baseColor =
          _parseColor(widget.categoryColors[entry.key] ?? '#10B981');
      final color = _applyMochaAccent(baseColor, entry.key);
      return PieChartSectionData(
        value: entry.value,
        color: color,
        radius: radius,
        title: '',
        borderSide: BorderSide(color: surfaceColor, width: 1.5),
      );
    }).toList();

    return PieChart(
      PieChartData(
        startDegreeOffset: 270,
        sections: sections,
        sectionsSpace: 0,
        centerSpaceRadius: radius * 1.4,
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final cleaned = hexColor.replaceAll('#', '').padLeft(8, 'FF');
    return Color(int.parse(cleaned, radix: 16));
  }

  Color _applyMochaAccent(Color base, String key) {
    final mocha = _catppuccinMochaColor(key);
    return Color.lerp(base, mocha, 0.28) ?? base;
  }

  Color _catppuccinMochaColor(String key) {
    const palette = [
      Color(0xFFF5E0DC), // rosewater
      Color(0xFFF2CDCD), // flamingo
      Color(0xFFF5C2E7), // pink
      Color(0xFFCBA6F7), // mauve
      Color(0xFFF38BA8), // red
      Color(0xFFEBA0AC), // maroon
      Color(0xFFFAB387), // peach
      Color(0xFFF9E2AF), // yellow
      Color(0xFFA6E3A1), // green
      Color(0xFF94E2D5), // teal
      Color(0xFF89DCEB), // sky
      Color(0xFF74C7EC), // sapphire
      Color(0xFF89B4FA), // blue
      Color(0xFFB4BEFE), // lavender
    ];
    final index = key.hashCode.abs() % palette.length;
    return palette[index];
  }
}
