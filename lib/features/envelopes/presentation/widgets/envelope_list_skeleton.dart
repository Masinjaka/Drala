import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EnvelopeListSkeleton extends StatelessWidget {
  const EnvelopeListSkeleton({this.itemCount = 4, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colors.surfaceContainerHighest,
      highlightColor: colors.onSurface.withValues(alpha: .1),
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              key: Key('envelope-skeleton-card'),
              height: 102,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
