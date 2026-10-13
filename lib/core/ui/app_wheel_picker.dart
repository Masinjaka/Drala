import 'package:bottom_picker/bottom_picker.dart';
import 'package:budgets/core/ui/app_sheet_header.dart';
import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:budgets/core/ui/app_sheet_surface.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart' show DatePickerDateOrder;
import 'package:flutter/material.dart';

class AppWheelPicker {
  const AppWheelPicker._();

  static Future<DateTime?> date(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String title = 'Select a date',
  }) {
    return _showDateTime(
      context,
      height: 360,
      pickerBuilder: (sheetContext) {
        return BottomPicker<DateTime>.date(
          initialDateTime: _clamp(initialDate, firstDate, lastDate),
          minDateTime: firstDate,
          maxDateTime: lastDate,
          dateOrder: DatePickerDateOrder.dmy,
          height: 360,
          itemExtent: 44,
          backgroundColor: _background(sheetContext),
          pickerTextStyle: _pickerTextStyle(sheetContext),
          headerBuilder: (_) => _header(sheetContext, title),
          buttonBuilder: (instance, _) => _doneButton(
            sheetContext,
            () => Navigator.pop(sheetContext, instance.currentValue),
          ),
        );
      },
    );
  }

  static Future<DateTime?> monthYear(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String title = 'Select a month',
  }) {
    return _showDateTime(
      context,
      height: 340,
      pickerBuilder: (sheetContext) {
        return BottomPicker<DateTime>.monthYear(
          initialDateTime: _clamp(initialDate, firstDate, lastDate),
          minDateTime: firstDate,
          maxDateTime: lastDate,
          height: 340,
          itemExtent: 44,
          backgroundColor: _background(sheetContext),
          pickerTextStyle: _pickerTextStyle(sheetContext),
          headerBuilder: (_) => _header(sheetContext, title),
          buttonBuilder: (instance, _) => _doneButton(
            sheetContext,
            () => Navigator.pop(sheetContext, instance.currentValue),
          ),
        );
      },
    );
  }

  static Future<TimeOfDay?> time(
    BuildContext context, {
    required TimeOfDay initialTime,
    String title = 'Select a time',
  }) {
    return showAppSheet<TimeOfDay>(
      context,
      builder: (sheetContext) {
        final picker = BottomPicker<DateTime>.time(
          initialTime: Time(
            hours: initialTime.hour,
            minutes: initialTime.minute,
          ),
          minTime: Time(),
          maxTime: Time(hours: 23, minutes: 59),
          use24hFormat: MediaQuery.alwaysUse24HourFormatOf(sheetContext),
          showTimeSeparator: true,
          height: 340,
          itemExtent: 44,
          backgroundColor: _background(sheetContext),
          pickerTextStyle: _pickerTextStyle(sheetContext),
          headerBuilder: (_) => _header(sheetContext, title),
          buttonBuilder: (instance, _) => _doneButton(sheetContext, () {
            final value = instance.currentValue;
            Navigator.pop(
              sheetContext,
              value == null ? null : TimeOfDay.fromDateTime(value),
            );
          }),
        );
        return AppSheetSurface(height: 340, child: picker);
      },
    );
  }

  static Future<DateTime?> _showDateTime(
    BuildContext context, {
    required double height,
    required WidgetBuilder pickerBuilder,
  }) {
    return showAppSheet<DateTime>(
      context,
      builder: (sheetContext) => AppSheetSurface(
        height: height,
        child: pickerBuilder(sheetContext),
      ),
    );
  }

  static TextStyle _pickerTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18);

  static Widget _header(BuildContext context, String title) {
    return AppSheetHeader(
      title: title,
      titleKey: const Key('app-wheel-picker-title'),
      closeKey: const Key('app-wheel-picker-close'),
      onClose: () => Navigator.pop(context),
    );
  }

  static Widget _doneButton(BuildContext context, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: CustomButton(
        key: const Key('app-wheel-picker-done'),
        text: context.l10n.done,
        height: 40,
        borderRadius: BorderRadius.circular(6),
        onPressed: onPressed,
      ),
    );
  }

  static Color _background(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLowest;

  static DateTime _clamp(DateTime value, DateTime min, DateTime max) {
    if (value.isBefore(min)) return min;
    if (value.isAfter(max)) return max;
    return value;
  }
}
