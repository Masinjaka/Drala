import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/app_card_theme.dart';
import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:flutter/material.dart';

class WalletCardSkeleton extends StatelessWidget {
  const WalletCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 180,
        padding: const EdgeInsets.fromLTRB(19, 18, 14, 19),
        decoration: BoxDecoration(
          boxShadow: AppCardTheme.shadows(context),
          color: AppFinanceSurfaceTheme.field(context),
          borderRadius: AppFinanceSurfaceTheme.cardRadius,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueSkeleton(width: 100, height: 16),
            Spacer(),
            ValueSkeleton(width: 125, height: 27),
          ],
        ),
      );
}
