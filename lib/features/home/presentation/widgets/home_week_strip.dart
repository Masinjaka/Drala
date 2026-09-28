import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeWeekStrip extends StatelessWidget {
  const HomeWeekStrip({
    required this.selectedDate,
    required this.today,
    required this.onDateSelected,
    super.key,
  });

  final DateTime selectedDate;
  final DateTime today;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final start =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final locale = Localizations.localeOf(context).toLanguageTag();
    return SizedBox(
      height: 58,
      child: Row(
        children: List.generate(7, (index) {
          final date = start.add(Duration(days: index));
          final selected = DateUtils.isSameDay(date, selectedDate);
          final enabled = !date.isAfter(DateUtils.dateOnly(today));
          return Expanded(
            child: InkWell(
              key: Key(
                'home-week-day-${DateFormat('yyyy-MM-dd').format(date)}',
              ),
              onTap: enabled ? () => onDateSelected(date) : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                key: selected ? const Key('home-week-selected-day') : null,
                margin: EdgeInsets.only(right: index == 6 ? 0 : 4),
                decoration: BoxDecoration(
                  border: selected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.onSurface)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.E(locale).format(date).substring(0, 1),
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${date.day}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
