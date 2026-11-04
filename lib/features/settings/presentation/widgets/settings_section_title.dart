import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:flutter/material.dart';

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 12),
        child: Semantics(
          header: true,
          child: Text(text, style: AppSettingsTheme.menuLabel(context)),
        ),
      );
}
