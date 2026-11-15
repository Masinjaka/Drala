import 'package:budgets/core/layout/app_scroll_padding.dart';
import 'package:budgets/features/settings/domain/providers/theme_provider.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_choice_tile.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_group.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budgets/l10n/app_localizations_context.dart';

class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({this.onSelected, super.key});

  final Future<void> Function(String)? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themeProvider);
    return SettingsPageShell(
      title: context.l10n.theme,
      child: ListView(
        padding: AppScrollPadding.insets(context, top: 24, bottom: 28),
        children: [
          SettingsMenuGroup(
            flat: true,
            items: [
              _choice(ref, current, ThemeMode.light, ThemeOptions.light,
                  context.l10n.light, Icons.light_mode),
              _choice(ref, current, ThemeMode.dark, ThemeOptions.dark,
                  context.l10n.dark, Icons.dark_mode),
              _choice(ref, current, ThemeMode.system, ThemeOptions.system,
                  context.l10n.system, Icons.brightness_auto),
            ],
          ),
        ],
      ),
    );
  }

  Widget _choice(
    WidgetRef ref,
    ThemeMode current,
    ThemeMode mode,
    ThemeOptions option,
    String label,
    IconData icon,
  ) {
    return SettingsChoiceTile(
      title: label,
      leading: Icon(icon, size: 20),
      selected: current == mode,
      showSelectionIndicator: true,
      onTap: () async {
        await ref.read(themeProvider.notifier).setTheme(option);
        await onSelected?.call(option.name);
      },
    );
  }
}
