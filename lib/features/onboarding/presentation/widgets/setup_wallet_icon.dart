import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';

class SetupWalletIcon extends StatelessWidget {
  const SetupWalletIcon({required this.kind, super.key});

  final String kind;

  @override
  Widget build(BuildContext context) {
    final appearance = switch (kind) {
      'cash' => ('💵', AppTheme.onboardingYellow),
      'bank' => ('🏦', AppTheme.onboardingLavender),
      _ => ('📱', AppTheme.onboardingBlue),
    };
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: appearance.$2, shape: BoxShape.circle),
      child: Text(
        appearance.$1,
        style: AppTextTheme.onboardingEmoji(context, 24),
      ),
    );
  }
}
