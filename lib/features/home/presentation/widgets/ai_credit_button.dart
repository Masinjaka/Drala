import 'package:budgets/core/navigation/app_modal_page_route.dart';
import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/features/plans/presentation/pages/plan_page.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class AiCreditButton extends StatelessWidget {
  const AiCreditButton(
      {required this.remaining, required this.unlimited, super.key});
  final int? remaining;
  final bool unlimited;

  static void openPlans(BuildContext context) => Navigator.of(context)
      .push(AppModalPageRoute<void>(builder: (_) => const PlanPage()));

  @override
  Widget build(BuildContext context) => Tooltip(
      message: unlimited
          ? context.l10n.unlimitedAiRequests
          : context.l10n.aiRequestsRemaining(remaining ?? 5),
      child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: AppEnvelopeTheme.radius,
              boxShadow: AppEnvelopeTheme.shadows(context)),
          child: TextButton(
              key: const Key('activity-ai-credits'),
              onPressed: () => openPlans(context),
              style: AppEnvelopeTheme.yearButton(context),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.auto_awesome, size: 16),
                const SizedBox(width: 8),
                SizedBox.square(
                    dimension: 26,
                    child: Stack(alignment: Alignment.center, children: [
                      Positioned.fill(
                          child: CircularProgressIndicator(
                              value: unlimited
                                  ? 1
                                  : ((remaining ?? 5) / 5).clamp(0.0, 1.0),
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.primary,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant)),
                      Text(unlimited ? '∞' : '${remaining ?? 5}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ])),
              ]))));
}
