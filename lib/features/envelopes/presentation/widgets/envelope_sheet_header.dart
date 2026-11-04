import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnvelopeSheetHeader extends StatelessWidget {
  const EnvelopeSheetHeader({required this.month, super.key});

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.newEnvelope,
          style: const AppTextStyle(AppTextRole.sheetTitle),
        ),
        const SizedBox(height: 3),
        Text(
          DateFormat.yMMMM(locale).format(month),
          style: AppTextStyle(AppTextRole.supporting,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
