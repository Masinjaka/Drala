import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_choice_tile.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_selection_indicator.dart';
import 'package:flutter/material.dart';

class SettingsCurrencyChoice extends StatelessWidget {
  const SettingsCurrencyChoice({
    required this.code,
    required this.title,
    required this.symbol,
    required this.selected,
    required this.loading,
    required this.first,
    required this.last,
    required this.onTap,
    super.key,
  });

  final String code;
  final String title;
  final String symbol;
  final bool selected;
  final bool loading;
  final bool first;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        selected: selected,
        child: AppCardSurface(
          color: AppSettingsTheme.surface(context),
          borderRadius: BorderRadius.vertical(
            top: first
                ? AppSettingsTheme.outerRadius
                : AppSettingsTheme.innerRadius,
            bottom: last
                ? AppSettingsTheme.outerRadius
                : AppSettingsTheme.innerRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 60),
            child: SettingsChoiceTile(
              title: title,
              leading: const Icon(Icons.currency_exchange, size: 20),
              subtitle: code,
              selected: selected,
              onTap: loading ? null : onTap,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(symbol, style: AppSettingsTheme.supportingLabel(context)),
                const SizedBox(width: 8),
                SettingsSelectionIndicator(
                    selected: selected, loading: loading),
              ]),
            ),
          ),
        ),
      );
}
