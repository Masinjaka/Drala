import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:flutter/material.dart';

class SettingsSelectedMark extends StatelessWidget {
  const SettingsSelectedMark({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.onSurface,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.check_rounded,
            color: AppSettingsTheme.selectionForeground(context),
            size: 15,
          ),
        ),
      ),
    );
  }
}
