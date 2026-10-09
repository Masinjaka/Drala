import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SetupCurrencySkeleton extends StatelessWidget {
  const SetupCurrencySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final rows = ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 28),
      itemCount: 7,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Container(
        height: 40,
        decoration: BoxDecoration(
          color: reducedMotion
              ? colors.onSurface.withValues(alpha: .07)
              : colors.onSurface,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    return ExcludeSemantics(
      child: reducedMotion
          ? rows
          : Shimmer.fromColors(
              period: const Duration(milliseconds: 1100),
              baseColor: colors.onSurface.withValues(alpha: .07),
              highlightColor: colors.onSurface.withValues(alpha: .16),
              child: rows,
            ),
    );
  }
}
