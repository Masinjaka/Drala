import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:flutter/material.dart';

class DetailListSkeleton extends StatelessWidget {
  const DetailListSkeleton({this.count = 5, super.key});
  final int count;
  @override
  Widget build(BuildContext context) => ListView.separated(
      padding: const EdgeInsets.all(29),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20)),
          child: const Row(children: [
            ValueSkeleton(width: 24, height: 24),
            SizedBox(width: 16),
            Expanded(child: ValueSkeleton())
          ])));
}
