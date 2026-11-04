import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:flutter/material.dart';

class EnvelopeCardHeading extends StatelessWidget {
  const EnvelopeCardHeading({required this.envelope, super.key});
  final Envelope envelope;

  @override
  Widget build(BuildContext context) => Row(children: [
        SizedBox.square(
            dimension: 32,
            child: CategoryIcon(
              iconKey: envelope.iconKey,
              emoji: envelope.emoji,
              colorHex: envelope.color,
              size: AppCategoryIconTheme.size,
            )),
        const SizedBox(width: 15),
        Expanded(
            child: Text(envelope.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppEnvelopeTheme.name(context))),
        const SizedBox(width: 12),
        Text(
            AmountVisibilityScope.isVisibleOf(context)
                ? '${(envelope.progress * 100).round()}%'
                : '•••',
            style: AppEnvelopeTheme.percentage(context)),
      ]);
}
