import 'package:budgets/features/home/presentation/widgets/ai_credit_button.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class AiCreditNotice extends StatelessWidget {
  const AiCreditNotice({super.key});
  @override
  Widget build(BuildContext context) => TextButton(
      key: const Key('ai-credit-exhausted-notice'),
      onPressed: () => AiCreditButton.openPlans(context),
      child: Text(context.l10n.dailyAiCreditsExhausted,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall));
}
