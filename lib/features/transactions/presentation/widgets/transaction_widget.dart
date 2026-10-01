import 'dart:async';

import 'package:budgets/features/transactions/domain/model/transaction_model.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_detail_sheet_route.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_list_item_content.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vibration/vibration.dart';
import 'package:budgets/features/transactions/domain/providers/transaction_provider.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/currency/currency_provider.dart';

class TransactionListItem extends ConsumerStatefulWidget {
  final TransactionModel transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  ConsumerState<TransactionListItem> createState() =>
      _TransactionListItemState();
}

class _TransactionListItemState extends ConsumerState<TransactionListItem>
    with SingleTickerProviderStateMixin {
  static const double _deletePaneExtentRatio = 0.20;

  bool _hasTriggeredHalfSwipeHaptic = false;
  bool _canVibrate = true;
  double _swipeProgress = 0;
  late final SlidableController _slidableController;

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController(this)
      ..animation.addListener(_handleSlideAnimation);
    _initVibration();
  }

  @override
  void dispose() {
    _slidableController.animation.removeListener(_handleSlideAnimation);
    _slidableController.dispose();
    super.dispose();
  }

  Future<void> _initVibration() async {
    try {
      _canVibrate = (await Vibration.hasVibrator()) == true;
    } catch (_) {
      _canVibrate = false;
    }
  }

  void _handleSlideAnimation() {
    final ratio = _slidableController.ratio.abs();
    final progress = (ratio / _deletePaneExtentRatio).clamp(0.0, 1.0);
    if ((progress - _swipeProgress).abs() > 0.005 && mounted) {
      setState(() => _swipeProgress = progress);
    }
    if (!_hasTriggeredHalfSwipeHaptic && progress >= 0.5) {
      if (_canVibrate) unawaited(Vibration.vibrate(duration: 30));
      _hasTriggeredHalfSwipeHaptic = true;
    } else if (_hasTriggeredHalfSwipeHaptic && progress < 0.2) {
      _hasTriggeredHalfSwipeHaptic = false;
    }
  }

  Future<void> _resetSwipeFeedbackState() async {
    if (_hasTriggeredHalfSwipeHaptic || _swipeProgress > 0) {
      if (mounted) {
        setState(() {
          _hasTriggeredHalfSwipeHaptic = false;
          _swipeProgress = 0;
        });
      } else {
        _hasTriggeredHalfSwipeHaptic = false;
        _swipeProgress = 0;
      }
    }
    if (_slidableController.ratio != 0) {
      await _slidableController.close(duration: 120.ms);
    }
  }

  Future<void> _handleDeleteAction() async {
    final transaction = widget.transaction;
    final shouldDelete = await showDeleteConfirmationDialog(
      context: context,
      title: context.l10n.deleteTransactionQuestion,
      message: context.l10n.deleteTransactionDescription,
    );
    if (!shouldDelete || transaction.id == null) {
      await _resetSwipeFeedbackState();
      return;
    }
    await _resetSwipeFeedbackState();
    if (!mounted) return;
    try {
      await ref.read(transactionsProvider.notifier).deleteTransaction(
          transaction.id!,
          transaction.transactionType ?? TransactionType.expense,
          transaction: transaction);
    } catch (e) {
      debugPrint("Error deleting transaction: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    final cardBorderRadius = BorderRadius.circular(16);
    final currencyState = ref.watch(currencyControllerProvider);
    final currency = currencyState.asData?.value;

    final card = ClipRRect(
      borderRadius: cardBorderRadius,
      clipBehavior: Clip.antiAlias,
      child: Slidable(
        controller: _slidableController,
        key: Key(transaction.id ?? DateTime.now().toString()),
        enabled: true,
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: _deletePaneExtentRatio,
          children: [
            CustomSlidableAction(
              autoClose: false,
              padding: EdgeInsets.only(left: 4),
              backgroundColor: const Color.fromARGB(0, 190, 17, 17),
              onPressed: (_) => _handleDeleteAction(),
              child: SizedBox.expand(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Flexible(
                      child: Icon(Icons.delete_outline,
                          color: Colors.white, size: 18)),
                ]),
              ).animate(target: _swipeProgress).custom(
                    duration: 120.ms,
                    curve: Curves.linear,
                    builder: (context, value, child) => DecoratedBox(
                      decoration: BoxDecoration(
                          color: Color.lerp(Colors.orange, Colors.red, value),
                          borderRadius: cardBorderRadius),
                      child: child,
                    ),
                  ),
            ),
          ],
        ),
        child: TransactionListItemContent(
          transaction: transaction,
          currency: currency,
          borderRadius: cardBorderRadius,
          onTap: () => showTransactionDetailSheet(context, transaction),
        ),
      ),
    );

    return card;
  }
}
