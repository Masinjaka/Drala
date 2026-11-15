import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'home_overview_skeleton_shimmer.dart';
import 'home_overview_skeleton_shape.dart';
import 'package:flutter/material.dart';

class HomeOverviewEnvelopeSkeleton extends StatelessWidget {
  const HomeOverviewEnvelopeSkeleton({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: AppHomeOverviewTheme.envelopeCardHeight,
        child: AppCardSurface(
          color: AppHomeOverviewTheme.surface(context),
          borderRadius: BorderRadius.circular(24),
          child: const HomeOverviewSkeletonShimmer(
              child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  HomeOverviewSkeletonShape(width: 32, height: 32),
                  SizedBox(width: 12),
                  Expanded(child: HomeOverviewSkeletonShape(height: 14)),
                ]),
                Spacer(),
                HomeOverviewSkeletonShape(width: 48, height: 12),
                SizedBox(height: 6),
                FractionallySizedBox(
                  widthFactor: .75,
                  child: HomeOverviewSkeletonShape(height: 24),
                ),
              ],
            ),
          )),
        ),
      );
}
