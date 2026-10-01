import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/home/domain/models/manual_entry_sheet_result.dart';
import 'package:budgets/features/home/presentation/widgets/finance_entry_detail_sheet.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_motion.dart';
import 'package:flutter/material.dart';

Future<ManualEntrySheetResult?> showFinanceEntryDetailSheet(
  BuildContext context, {
  required FinanceEntry entry,
  required Future<List<ManualEntryCategory>> categories,
  CurrencyState? currencyState,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    _FinanceEntryDetailRoute(
      entry: entry,
      categories: categories,
      currencyState: currencyState,
    ),
  );
}

class _FinanceEntryDetailRoute extends PopupRoute<ManualEntrySheetResult> {
  _FinanceEntryDetailRoute({
    required this.entry,
    required this.categories,
    required this.currencyState,
  });

  final FinanceEntry entry;
  final Future<List<ManualEntryCategory>> categories;
  final CurrencyState? currencyState;

  @override
  Color get barrierColor => Colors.black.withValues(alpha: 0.46);
  @override
  bool get barrierDismissible => true;
  @override
  String? get barrierLabel => 'Dismiss';
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 360);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FinanceEntryDetailSheet(
      entry: entry,
      categories: categories,
      currencyState: currencyState,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final position = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: animation, curve: transactionSheetCurve),
    );
    return SlideTransition(position: position, child: child);
  }
}
