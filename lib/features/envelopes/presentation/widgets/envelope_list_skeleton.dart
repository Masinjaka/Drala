import 'package:flutter/material.dart';
import 'package:budgets/core/ui/value_skeleton.dart';

class EnvelopeListSkeleton extends StatelessWidget {
  const EnvelopeListSkeleton({this.itemCount = 4, super.key});
  final int itemCount;
  @override
  Widget build(BuildContext context) => Column(
      children: List.generate(
          itemCount,
          (index) => Padding(
              padding: EdgeInsets.zero,
              child: Container(
                  key: const Key('envelope-skeleton-card'),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ValueSkeleton(
                          key: Key('envelope-title-skeleton'),
                          width: 88,
                          height: 16,
                        ),
                        const SizedBox(height: 20),
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueSkeleton(
                                key: Key('envelope-spent-skeleton'),
                                width: 64,
                                height: 18,
                              ),
                              ValueSkeleton(
                                key: Key('envelope-budget-skeleton'),
                                width: 56,
                                height: 18,
                              ),
                            ]),
                        const SizedBox(height: 12),
                        const ValueSkeleton(width: double.infinity, height: 12),
                      ])))));
}
