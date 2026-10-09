import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_motion.dart';
import 'package:flutter/material.dart';

Future<T?> showTransactionFormSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) =>
    showGeneralDialog<T>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: .46),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, _, __) => builder(context),
      transitionBuilder: (context, animation, _, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: transactionSheetCurve),
        ),
        child: child,
      ),
    );
