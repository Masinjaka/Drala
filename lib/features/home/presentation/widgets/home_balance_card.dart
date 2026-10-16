import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_primary_amount.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_visibility_button.dart';
import 'package:budgets/features/home/presentation/widgets/home_colors.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeBalanceCard extends StatelessWidget {
  const HomeBalanceCard({
    required this.balance,
    required this.income,
    required this.expenses,
    required this.currencyCode,
    this.isLoading = false,
    super.key,
  });

  final num balance;
  final num income;
  final num expenses;
  final String currencyCode;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const bannerColor = HomeColors.banner;
    final labelStyle = theme.textTheme.labelSmall!.copyWith(
      color: AppTheme.homeBannerText,
    );
    return Container(
      key: const Key('home-balance-card'),
      height: 109,
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 22, 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 48),
                child: Text(
                  context.l10n.availableBalance,
                  key: const Key('home-balance-label'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: labelStyle,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomLeft,
                child: HomeBalancePrimaryAmount(
                  balance: balance,
                  currencyCode: currencyCode,
                  isLoading: isLoading,
                  amountStyle: theme.textTheme.displaySmall!.copyWith(
                    color: AppTheme.homeBannerText,
                  ),
                  currencyStyle: AppTextTheme.currencyLabel(context).copyWith(
                    color: AppTheme.homeBannerText,
                  ),
                  onCompleted: _onAmountCompleted,
                ),
              ),
            ],
          ),
          const Positioned(
            top: -14,
            right: 0,
            child: HomeBalanceVisibilityButton(),
          ),
        ],
      ),
    );
  }

  static void _onAmountCompleted() {}
}
