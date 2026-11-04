import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_amount.dart';
import 'package:flutter/material.dart';

class HomeOverviewFlowPill extends StatelessWidget {
  const HomeOverviewFlowPill(
      {required this.amount,
      required this.currencyCode,
      required this.income,
      required this.label,
      required this.onPressed,
      this.loading = false,
      super.key});
  final num amount;
  final String currencyCode;
  final bool income;
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
      label: label,
      child: AppCardSurface(
        color: AppHomeOverviewTheme.surface(context),
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerLowest,
                    child: Icon(
                        income
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        size: 22,
                        color: income
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.error)),
                const SizedBox(width: 10),
                Expanded(
                    child: HomeOverviewAmount(
                        amount: amount,
                        currencyCode: currencyCode,
                        sign: income ? '+ ' : '- ',
                        loading: loading,
                        style: AppHomeOverviewTheme.label(context))),
              ])),
        ),
      ));
}
