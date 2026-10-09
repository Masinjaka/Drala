import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';

class EnvelopeAmount extends StatelessWidget {
  const EnvelopeAmount({
    required this.value,
    required this.currencyCode,
    this.gap = true,
    super.key,
  });

  final num value;
  final String currencyCode;
  final bool gap;

  static String compact(num value, {bool gap = false}) {
    final separator = gap ? ' ' : '';
    final divisor = value.abs() >= 1000000
        ? 1000000
        : value.abs() >= 1000
            ? 1000
            : 1;
    final scaled = value / divisor;
    final amount = scaled.toStringAsFixed(scaled % 1 == 0 ? 0 : 1);
    final unit = divisor == 1000000
        ? 'M'
        : divisor == 1000
            ? 'k'
            : '';
    return '$amount${unit.isEmpty ? '' : separator}$unit';
  }

  @override
  Widget build(BuildContext context) => Text.rich(
        TextSpan(children: [
          TextSpan(
            text: AmountVisibilityScope.isVisibleOf(context)
                ? compact(value, gap: gap)
                : '***',
          ),
          TextSpan(
            text: ' $currencyCode',
            style: AppTextTheme.currencyLabel(context),
          ),
        ]),
        style: AppTextTheme.envelopeAmount(context),
        maxLines: 1,
      );
}
