import 'package:flutter/material.dart';
import 'package:budgets/core/ui/list_item_entrance.dart';

class SetupListChoiceEntrance extends StatelessWidget {
  const SetupListChoiceEntrance({
    required this.index,
    required this.child,
    super.key,
  });

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ListItemEntrance(index: index, child: child);
}
