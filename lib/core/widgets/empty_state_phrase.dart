import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/core/widgets/empty_state_illustration.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_empty_state_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Shared illustrated empty state used across app sections.
class EmptyStatePhrase extends StatelessWidget {
  const EmptyStatePhrase({
    super.key,
    this.title,
    this.inlineMessage,
    this.subtitle,
    this.illustrationAsset,
    this.brief = false,
    this.icon,
    this.padding,
    this.action,
    this.titleStyle,
    this.illustrationWidth = AppEmptyStateTheme.illustrationWidth,
  }) : assert(title != null || inlineMessage != null);

  final String? title;
  final Widget? inlineMessage;
  final String? subtitle;
  final String? illustrationAsset;
  final bool brief;
  final FaIconData? icon;
  final EdgeInsetsGeometry? padding;
  final Widget? action;
  final TextStyle? titleStyle;
  final double illustrationWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? AppPageSpacing.insets(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyStateIllustration(
              width: illustrationWidth,
              asset: illustrationAsset ??
                  'assets/illustrations/empty-budgeting.png',
              lineArt: illustrationAsset != null,
            ),
            if (icon != null) ...[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: FaIcon(
                    icon,
                    size: 24,
                    color: AppIconForeground.resolve(
                      context,
                      Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            inlineMessage ??
                Text(
                  title!,
                  style: titleStyle ?? AppEmptyStateTheme.message(context),
                  textAlign: TextAlign.center,
                ),
            if (subtitle case final subtitle?) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppEmptyStateTheme.message(context),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 12), action!],
          ],
        ),
      ),
    );
  }
}
