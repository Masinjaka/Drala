import 'package:flutter/material.dart';

/// Opens auxiliary pickers in the entry surface's existing second page.
class TransactionPickerScope extends InheritedWidget {
  const TransactionPickerScope({
    required this.open,
    required super.child,
    super.key,
  });
  final Future<String?> Function(Widget Function(ValueChanged<String?>) builder)
      open;

  static TransactionPickerScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TransactionPickerScope>();

  @override
  bool updateShouldNotify(TransactionPickerScope oldWidget) => false;
}
