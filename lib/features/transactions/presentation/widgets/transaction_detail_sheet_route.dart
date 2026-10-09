import 'package:budgets/features/transactions/domain/model/transaction_model.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_detail_bottom_sheet.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_motion.dart';
import 'package:flutter/material.dart';

Future<bool?> showTransactionDetailSheet(
  BuildContext context,
  TransactionModel transaction,
) {
  return Navigator.of(context).push<bool>(
    _TransactionSheetRoute(transaction: transaction),
  );
}

class _TransactionSheetRoute extends PopupRoute<bool> {
  _TransactionSheetRoute({required this.transaction});

  final TransactionModel transaction;

  @override
  Color get barrierColor => Colors.black.withValues(alpha: 0.46);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 180);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return TransactionDetailBottomSheet(transaction: transaction);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final position = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(parent: animation, curve: transactionSheetCurve));
    return SlideTransition(position: position, child: child);
  }
}
