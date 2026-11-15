import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_amount.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeOverviewBalance extends StatelessWidget {
  const HomeOverviewBalance(
      {required this.balance,
      required this.currencyCode,
      required this.loading,
      this.amountKey,
      super.key});
  final num balance;
  final String currencyCode;
  final bool loading;
  final Key? amountKey;

  @override
  Widget build(BuildContext context) {
    final controller = AmountVisibilityScope.maybeControllerOf(context);
    final visible = controller?.isVisible ?? true;
    return Semantics(
      label: context.l10n.availableBalance,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: HomeOverviewAmount(
                      key: amountKey,
                      amount: balance,
                      currencyCode: currencyCode,
                      loading: loading,
                      style: AppHomeOverviewTheme.balance(context)))),
          IconButton(
              key: const Key('home-overview-visibility'),
              onPressed: controller?.toggle,
              tooltip:
                  visible ? context.l10n.hideBalance : context.l10n.showBalance,
              icon: Icon(visible ? Icons.visibility : Icons.visibility_off,
                  size: 20),
              color: Theme.of(context).colorScheme.onSurface),
        ]),
      ),
    );
  }
}
