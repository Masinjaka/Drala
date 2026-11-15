import 'package:budgets/features/settings/presentation/widgets/settings_menu_group.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_item.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class SettingsLegalSection extends StatelessWidget {
  const SettingsLegalSection(
      {required this.onTerms, required this.onPrivacy, super.key});

  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionTitle(context.l10n.legal),
          SettingsMenuGroup(items: [
            SettingsMenuItem(
              title: context.l10n.termsOfService,
              icon: Icons.description_rounded,
              onTap: onTerms,
            ),
            SettingsMenuItem(
              title: context.l10n.privacyPolicy,
              icon: Icons.shield_rounded,
              onTap: onPrivacy,
            ),
          ]),
        ],
      );
}
