import 'package:budgets/features/stats/presentation/widgets/bouncing_month_icon.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_wheel_picker.dart';
import 'package:budgets/features/stats/domain/providers/selected_date_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MonthYearPicker extends ConsumerWidget {
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;
  final void Function(DateTime)? onDateSelected;

  const MonthYearPicker({
    super.key,
    this.onPreviousMonth,
    this.onNextMonth,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final tabIndicatorColor = Theme.of(context).tabBarTheme.indicatorColor;
    final tabLabelColor = Theme.of(context).tabBarTheme.labelColor;
    final selectedDate = ref.watch(selectedDateProvider);
    final now = DateTime.now();

    final formatted = DateFormat('MMMM yyyy', 'fr').format(selectedDate);
    final formattedMonthYear =
        formatted[0].toUpperCase() + formatted.substring(1);

    // Check if we can go to next month (not beyond current month/year)
    final canGoToNextMonth = selectedDate.year < now.year ||
        (selectedDate.year == now.year && selectedDate.month < now.month);

    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          BouncingMonthIcon(
            icon: Icons.arrow_back_ios,
            size: 18,
            color: textColor,
            onTap: () {
              if (onPreviousMonth != null) {
                onPreviousMonth!();
              } else {
                ref.read(selectedDateProvider.notifier).previousMonth();
              }
            },
          ),
          // IconButton(
          //   padding: EdgeInsets.zero,
          //   constraints: BoxConstraints.tightFor(width: 32, height: 40),
          //   icon: Icon(Icons.arrow_back_ios, size: 16, color: textColor),
          //   onPressed: () {
          //     if (onPreviousMonth != null) {
          //       onPreviousMonth!();
          //     } else {
          //       ref.read(selectedDateProvider.notifier).previousMonth();
          //     }
          //   },
          // ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              final newDate = await AppWheelPicker.monthYear(
                context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: now,
                title: 'Select month and year',
              );
              if (newDate != null) {
                if (onDateSelected != null) {
                  onDateSelected!(newDate);
                } else {
                  ref.read(selectedDateProvider.notifier).setDate(newDate);
                }
              }
            },
            child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: tabIndicatorColor,
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  formattedMonthYear,
                  key: ValueKey(formattedMonthYear),
                  style: AppTextStyle(AppTextRole.body, color: tabLabelColor),
                ),
              ),
            ).animate(key: ValueKey(formattedMonthYear)).scaleX(
                begin: 0.95, end: 1.0, duration: 200.ms, curve: Curves.easeOut),
          ),
          const Spacer(),
          BouncingMonthIcon(
            icon: Icons.arrow_forward_ios,
            size: 18,
            color: canGoToNextMonth
                ? textColor
                : textColor?.withValues(alpha: 0.3),
            onTap: canGoToNextMonth
                ? () {
                    if (onNextMonth != null) {
                      onNextMonth!();
                    } else {
                      ref.read(selectedDateProvider.notifier).nextMonth();
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
