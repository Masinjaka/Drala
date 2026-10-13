import 'package:flutter/material.dart';

class AppSheetHeader extends StatelessWidget {
  const AppSheetHeader({
    required this.title,
    required this.onClose,
    this.titleKey,
    this.closeKey = const ValueKey('close-app-sheet'),
    super.key,
  });

  final String title;
  final VoidCallback onClose;
  final Key? titleKey;
  final Key closeKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            key: titleKey,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          key: closeKey,
          onPressed: onClose,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          icon: const Icon(Icons.close, size: 20),
        ),
      ],
    );
  }
}
