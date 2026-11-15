import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'home_overview_skeleton_shimmer.dart';
import 'home_overview_skeleton_shape.dart';
import 'package:flutter/material.dart';

class HomeOverviewTransactionSkeleton extends StatelessWidget {
  const HomeOverviewTransactionSkeleton(
      {required this.isFirst, required this.isLast, super.key});

  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) => AppCardSurface(
        color: AppHomeOverviewTheme.surface(context),
        shape: AppHomeOverviewTheme.transactionShape(
            isFirst: isFirst, isLast: isLast),
        child: const HomeOverviewSkeletonShimmer(
            child: SizedBox(
          height: AppHomeOverviewTheme.transactionMinHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              HomeOverviewSkeletonShape(width: 32, height: 32),
              SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                        widthFactor: .75,
                        child: HomeOverviewSkeletonShape(height: 13)),
                    SizedBox(height: 4),
                    HomeOverviewSkeletonShape(
                        width: double.infinity, height: 10),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  alignment: Alignment.centerRight,
                  widthFactor: .7,
                  child: HomeOverviewSkeletonShape(height: 14),
                ),
              ),
            ]),
          ),
        )),
      );
}
