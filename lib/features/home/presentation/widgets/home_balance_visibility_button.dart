import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_eye_painter.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeBalanceVisibilityButton extends StatelessWidget {
  const HomeBalanceVisibilityButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AmountVisibilityScope.maybeControllerOf(context);
    final isVisible = controller?.isVisible ?? true;
    final label =
        isVisible ? context.l10n.hideBalance : context.l10n.showBalance;

    return Semantics(
      button: true,
      label: label,
      child: InkResponse(
        key: const Key('home-balance-visibility-toggle'),
        onTap: controller?.toggle,
        radius: 22,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween(begin: .82, end: 1.0).animate(animation),
                  child: child,
                ),
              ),
              child: SizedBox(
                key: ValueKey('home-balance-eye-$isVisible'),
                width: 23,
                height: 16,
                child: CustomPaint(
                  key: const Key('home-balance-eye'),
                  painter: HomeBalanceEyePainter(
                    isVisible: isVisible,
                    color: AppTheme.homeBannerText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
