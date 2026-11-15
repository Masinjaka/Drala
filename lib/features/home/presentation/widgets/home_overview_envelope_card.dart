import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_amount.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_category_icon.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeOverviewEnvelopeCard extends StatelessWidget {
  const HomeOverviewEnvelopeCard(
      {required this.envelope,
      required this.onPressed,
      this.currency,
      super.key});
  final Envelope envelope;
  final CurrencyState? currency;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
      height: AppHomeOverviewTheme.envelopeCardHeight,
      child: AppCardSurface(
        color: AppHomeOverviewTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Row(children: [
                              HomeOverviewCategoryIcon(
                                  iconKey: envelope.iconKey,
                                  emoji: envelope.emoji,
                                  colorHex: envelope.color,
                                  accent: true),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Text(envelope.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          AppHomeOverviewTheme.label(context))),
                            ]))),
                    Text(context.l10n.spent,
                        style: AppHomeOverviewTheme.label(context)),
                    const SizedBox(height: 6),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: HomeOverviewAmount(
                            amount: currency?.convertToSelected(
                                    envelope.spent, envelope.currencyCode) ??
                                envelope.spent,
                            currencyCode:
                                currency?.code ?? envelope.currencyCode,
                            style:
                                AppHomeOverviewTheme.envelopeAmount(context))),
                  ]),
            )),
      ));
}
