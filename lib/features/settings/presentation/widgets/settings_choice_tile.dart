import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:flutter/material.dart';

import 'settings_selection_indicator.dart';

class SettingsChoiceTile extends StatelessWidget {
  const SettingsChoiceTile({
    required this.title,
    required this.leading,
    required this.onTap,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.selected = false,
    this.loading = false,
    this.showSelectionIndicator = false,
    super.key,
  });

  final String title;
  final Widget leading;
  final VoidCallback? onTap;
  final String? subtitle;
  final Widget? subtitleWidget;
  final Widget? trailing;
  final bool selected;
  final bool loading;
  final bool showSelectionIndicator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = AppSettingsTheme.foreground(context);
    final customSubtitle = subtitleWidget;
    final subtitleText = customSubtitle ??
        (subtitle == null
            ? null
            : Text(subtitle!, style: theme.textTheme.bodySmall));
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: subtitleText == null ? 51 : 62),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 35,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppSettingsTheme.iconSurface(context),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconTheme.merge(
                        data: IconThemeData(
                          color: AppSettingsTheme.iconForeground(context),
                          size: 19,
                        ),
                        child: DefaultTextStyle.merge(
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: foreground,
                          ),
                          child: leading,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppSettingsTheme.menuLabel(context).copyWith(
                          color: foreground,
                        ),
                      ),
                      if (subtitleText != null) ...[
                        const SizedBox(height: 2),
                        DefaultTextStyle.merge(
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: foreground.withValues(alpha: .78),
                          ),
                          child: subtitleText,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null || showSelectionIndicator) ...[
                  const SizedBox(width: 12),
                  IconTheme.merge(
                    data: IconThemeData(
                      color: AppSettingsTheme.iconForeground(context),
                    ),
                    child: DefaultTextStyle.merge(
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: foreground,
                      ),
                      child: trailing ??
                          SettingsSelectionIndicator(
                            selected: selected,
                            loading: loading,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
