import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:flutter/material.dart';

class ChatComposerSurface extends StatelessWidget {
  const ChatComposerSurface(
      {required this.expanded,
      required this.child,
      this.embedded = false,
      super.key});
  final bool expanded;
  final bool embedded;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        key: const Key('chat-input-container'),
        constraints: BoxConstraints(
            minHeight: expanded
                ? 85
                : embedded
                    ? 46
                    : 48,
            maxHeight: expanded
                ? 157
                : embedded
                    ? 46
                    : 48),
        margin: EdgeInsets.symmetric(horizontal: embedded ? 0 : 29),
        decoration: BoxDecoration(
            color: embedded
                ? AppActivitiesTheme.composer(context)
                : Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(embedded ? 24 : 12)),
        child: child,
      );
}
