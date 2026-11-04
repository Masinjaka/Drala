import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:flutter/material.dart';

class EnvelopeListSkeleton extends StatelessWidget {
  const EnvelopeListSkeleton({this.itemCount = 4, super.key});
  final int itemCount;
  @override
  Widget build(BuildContext context) => Column(
      children: List.generate(
          itemCount,
          (index) => KeyedSubtree(
              key: ValueKey(index),
              child: Container(
                key: const Key('envelope-skeleton-card'),
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.fromLTRB(15, 13, 15, 18),
                decoration: BoxDecoration(
                    color: AppEnvelopeTheme.surface(context),
                    borderRadius: AppEnvelopeTheme.cardRadius(
                        first: index == 0, last: index == itemCount - 1)),
                child: const Column(children: [
                  Row(children: [
                    ValueSkeleton(width: 32, height: 32),
                    SizedBox(width: 15),
                    ValueSkeleton(
                        key: Key('envelope-title-skeleton'),
                        width: 88,
                        height: 16)
                  ]),
                  SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueSkeleton(
                            key: Key('envelope-spent-skeleton'),
                            width: 64,
                            height: 18),
                        ValueSkeleton(
                            key: Key('envelope-budget-skeleton'),
                            width: 56,
                            height: 18)
                      ]),
                  SizedBox(height: 12),
                  ValueSkeleton(width: double.infinity, height: 5),
                ]),
              ))));
}
