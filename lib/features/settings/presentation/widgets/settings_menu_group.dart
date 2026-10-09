import 'package:flutter/material.dart';
import 'package:budgets/core/ui/detail_enter_transition.dart';

class SettingsMenuGroup extends StatelessWidget {
  const SettingsMenuGroup({required this.items, super.key});

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < items.length; index++) ...[
            DetailEnterTransition(child: items[index]),
            if (index != items.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.1),
              ),
          ],
        ],
      ),
    );
  }
}
