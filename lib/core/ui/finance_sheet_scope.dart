import 'package:flutter/widgets.dart';

class FinanceSheetScope extends InheritedWidget {
  const FinanceSheetScope({required super.child, super.key});
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FinanceSheetScope>() != null;
  @override
  bool updateShouldNotify(FinanceSheetScope oldWidget) => false;
}
