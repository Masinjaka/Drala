import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/home/presentation/widgets/animated_compact_amount.dart';
import 'package:flutter/material.dart';

class HomeBalancePrimaryAmount extends StatelessWidget {
  const HomeBalancePrimaryAmount({
    required this.balance,
    required this.currencyCode,
    required this.isLoading,
    required this.amountStyle,
    required this.currencyStyle,
    required this.onCompleted,
    super.key,
  });

  final num balance;
  final String currencyCode;
  final bool isLoading;
  final TextStyle amountStyle;
  final TextStyle currencyStyle;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Text(
        '-',
        key: const Key('home-balance-loading-amount'),
        style: amountStyle,
      );
    }
    final isVisible = AmountVisibilityScope.isVisibleOf(context);
    const duration = Duration(milliseconds: 260);
    return AnimatedSize(
      duration: duration,
      curve: Curves.easeInOutCubic,
      alignment: Alignment.bottomLeft,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (currentChild, previousChildren) => Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        ),
        transitionBuilder: (child, animation) {
          final isHidden = child.key == const ValueKey('hidden-home-balance');
          final offset = Tween<Offset>(
            begin: Offset(isHidden ? .65 : -.08, 0),
            end: Offset.zero,
          ).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: offset,
              child: ScaleTransition(
                alignment: Alignment.bottomLeft,
                scale: Tween(begin: .92, end: 1.0).animate(animation),
                child: child,
              ),
            ),
          );
        },
        child: isVisible
            ? Row(
                key: const ValueKey('visible-home-balance'),
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedCompactAmount(
                    value: balance,
                    key: const Key('home-balance-amount'),
                    style: amountStyle,
                    beginNearTarget: true,
                    respectAmountVisibility: false,
                    onCompleted: onCompleted,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currencySymbolForCode(currencyCode),
                    key: const Key('home-balance-currency'),
                    maxLines: 1,
                    style: currencyStyle,
                  ),
                ],
              )
            : Text(
                '***',
                key: const ValueKey('hidden-home-balance'),
                maxLines: 1,
                style: amountStyle,
              ),
      ),
    );
  }
}
