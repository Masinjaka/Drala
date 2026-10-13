import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';

class HomeOperationPrivacyAmount extends StatelessWidget {
  const HomeOperationPrivacyAmount({
    required this.id,
    required this.text,
    required this.style,
    super.key,
  });

  final String id;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final isVisible = AmountVisibilityScope.isVisibleOf(context);
    final amountStyle = AppTextTheme.amount(
      style ?? DefaultTextStyle.of(context).style,
    );
    const duration = Duration(milliseconds: 260);

    return AnimatedSize(
      duration: duration,
      curve: Curves.easeInOutCubic,
      alignment: Alignment.centerRight,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (currentChild, previousChildren) => Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerRight,
          children: [
            for (final child in previousChildren)
              Positioned(right: 0, child: child),
            if (currentChild != null) currentChild,
          ],
        ),
        transitionBuilder: (child, animation) {
          final isHidden = child.key == ValueKey('hidden-operation-$id');
          final offset = Tween<Offset>(
            begin: Offset(isHidden ? -.65 : .08, 0),
            end: Offset.zero,
          ).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: offset,
              child: ScaleTransition(
                alignment: Alignment.centerRight,
                scale: Tween(begin: .92, end: 1.0).animate(animation),
                child: child,
              ),
            ),
          );
        },
        child: Text(
          isVisible ? text : '***',
          key: ValueKey(
            isVisible ? 'visible-operation-$id' : 'hidden-operation-$id',
          ),
          maxLines: 1,
          style: amountStyle,
        ),
      ),
    );
  }
}
