import 'package:budgets/core/ui/month_carousel.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:flutter/material.dart';

class MonthPickerHeader extends StatelessWidget {
  const MonthPickerHeader(
      {required this.month,
      required this.onChanged,
      required this.onPickMonth,
      required this.canGoNext,
      this.pickerKey,
      super.key});
  final DateTime month;
  final ValueChanged<int> onChanged;
  final VoidCallback onPickMonth;
  final bool canGoNext;
  final Key? pickerKey;
  @override
  Widget build(BuildContext context) => Column(children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('${month.year}',
                key: const Key('month-year'),
                style: Theme.of(context).textTheme.bodySmall)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
              child: MonthCarousel(
                  month: month, onChanged: onChanged, canGoNext: canGoNext)),
          const SizedBox(width: 8),
          OutlinedSquareButton(
              key: pickerKey,
              icon: Icons.calendar_month_outlined,
              tooltip: MaterialLocalizations.of(context).datePickerHelpText,
              onPressed: onPickMonth),
        ]),
      ]);
}
