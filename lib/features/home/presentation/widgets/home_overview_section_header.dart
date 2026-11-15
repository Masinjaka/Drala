import 'package:budgets/core/ui/app_interaction_theme.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeOverviewSectionHeader extends StatelessWidget {
  const HomeOverviewSectionHeader(
      {required this.title,
      required this.onSeeMore,
      this.showSeeMore = true,
      this.reserveActionSpace = false,
      super.key});
  final bool showSeeMore;
  final bool reserveActionSpace;
  final String title;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: Text(title, style: AppHomeOverviewTheme.section(context))),
        if (showSeeMore || reserveActionSpace)
          Visibility(
              visible: showSeeMore,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: TextButton(
                  onPressed: onSeeMore,
                  style: AppInteractionTheme.withoutPressFeedback(
                      TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          textStyle: AppHomeOverviewTheme.label(context),
                          padding:
                              const EdgeInsetsDirectional.only(start: 12))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(context.l10n.seeMore),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 18),
                  ]))),
      ]);
}
