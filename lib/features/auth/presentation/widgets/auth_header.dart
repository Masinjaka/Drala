import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.title, this.onBack, super.key});
  final String title;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (onBack != null) ...[
          CustomButton.icon(
              icon: Icons.arrow_back_rounded,
              iconSize: AppHeaderMetrics.iconSize,
              width: AppHeaderMetrics.buttonSize,
              height: AppHeaderMetrics.buttonSize,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              onPressed: onBack,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip),
          const SizedBox(height: 24),
        ],
        Text(title, style: AppTextTheme.authTitle(context)),
        const SizedBox(height: 23),
      ]);
}
