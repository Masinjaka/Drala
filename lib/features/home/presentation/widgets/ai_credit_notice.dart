import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class AiCreditNotice extends StatelessWidget {
  const AiCreditNotice({super.key});
  @override
  Widget build(BuildContext context) => Padding(
      key: const Key('ai-credit-exhausted-notice'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(context.l10n.dailyAiCreditsExhausted,
          textAlign: TextAlign.center,
          style: AppActivitiesTheme.creditNotice(context)));
}
