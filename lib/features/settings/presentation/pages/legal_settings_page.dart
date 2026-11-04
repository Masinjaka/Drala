import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class LegalSettingsPage extends StatelessWidget {
  const LegalSettingsPage.terms({super.key}) : isTerms = true;

  const LegalSettingsPage.privacy({super.key}) : isTerms = false;

  final bool isTerms;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return SettingsPageShell(
      title:
          isTerms ? localizations.termsOfService : localizations.privacyPolicy,
      child: ListView(
        padding: AppPageSpacing.insets(context, top: 24, bottom: 28),
        children: [
          Text(
            isTerms ? localizations.termsIntro : localizations.privacyIntro,
            style: const AppTextStyle(AppTextRole.sheetTitle),
          ),
          const SizedBox(height: 18),
          Text(
            isTerms ? localizations.termsDetails : localizations.privacyDetails,
            style: const AppTextStyle(AppTextRole.body, height: 1.6),
          ),
          const SizedBox(height: 24),
          Text(
            localizations.legalLastUpdated,
            style: AppTextStyle(AppTextRole.supporting,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
