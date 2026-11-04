import 'package:flutter/material.dart';

class SelectableItem extends StatelessWidget {
  const SelectableItem(
      {required this.child,
      required this.selecting,
      required this.selected,
      required this.onToggle,
      this.enabled = true,
      this.selectionKey,
      super.key});
  final Widget child;
  final bool selecting;
  final bool selected;
  final bool enabled;
  final VoidCallback onToggle;
  final Key? selectionKey;

  @override
  Widget build(BuildContext context) => !selecting
      ? child
      : Row(children: [
          Checkbox(
              key: selectionKey,
              value: selected,
              onChanged: enabled ? (_) => onToggle() : null),
          Expanded(child: child),
        ]);
}
