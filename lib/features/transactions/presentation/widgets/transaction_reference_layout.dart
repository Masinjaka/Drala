import 'package:flutter/material.dart';
import 'package:budgets/core/ui/list_item_entrance.dart';

/// Scrollable fields and an action area that remains above the keyboard.
class TransactionReferenceLayout extends StatelessWidget {
  const TransactionReferenceLayout(
      {required this.children,
      required this.actions,
      this.entranceKey,
      super.key});
  final List<Widget> children;
  final Widget actions;
  final Object? entranceKey;
  @override
  Widget build(BuildContext context) => Column(children: [
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < children.length; i++)
                        if (entranceKey != null &&
                            i >= 4 &&
                            children[i] is! SizedBox)
                          ListItemEntrance(
                              index: (i - 4) ~/ 2,
                              replayKey: entranceKey,
                              child: children[i])
                        else
                          children[i]
                    ]))),
        Padding(
            padding: const EdgeInsets.fromLTRB(32, 12, 32, 16), child: actions),
      ]);
}
