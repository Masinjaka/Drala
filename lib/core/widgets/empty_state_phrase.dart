import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/core/widgets/empty_state_illustration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Shared illustrated empty state used across app sections.
class EmptyStatePhrase extends StatelessWidget {
  const EmptyStatePhrase({
    super.key,
    required this.title,
    this.subtitle,
    this.illustrationAsset,
    this.brief = false,
    this.icon,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final String? illustrationAsset;
  final bool brief;
  final FaIconData? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyStateIllustration(
              width: 160,
              asset: illustrationAsset ??
                  'assets/illustrations/empty-budgeting.png',
              lineArt: illustrationAsset != null,
            ),
            const SizedBox(height: 12),
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
            Text(
              title,
              style: brief
                  ? Theme.of(context).textTheme.bodyMedium
                  : Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle case final subtitle?) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
