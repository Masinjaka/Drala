import 'package:flutter/material.dart';

class TransactionEditScrollView extends StatelessWidget {
  const TransactionEditScrollView({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverFillRemaining(hasScrollBody: false, child: child),
        ],
      );
}
