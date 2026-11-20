import 'package:budgets/core/ui/app_loader.dart';
import 'package:flutter/material.dart';

class TransactionLoadingState extends StatelessWidget {
  const TransactionLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppLoader());
  }
}
