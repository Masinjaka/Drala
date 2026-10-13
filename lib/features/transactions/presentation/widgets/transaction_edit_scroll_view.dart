import 'package:budgets/features/transactions/presentation/widgets/transaction_form_scroll_physics.dart';
import 'package:flutter/material.dart';

class TransactionEditScrollView extends StatelessWidget {
  const TransactionEditScrollView({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        physics: const TransactionFormScrollPhysics(),
        slivers: [
          SliverFillRemaining(hasScrollBody: false, child: child),
        ],
      );
}
