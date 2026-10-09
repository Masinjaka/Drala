import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_text_theme.dart';

class SetupPageLayout extends StatelessWidget {
  const SetupPageLayout({
    required this.title,
    required this.subtitle,
    required this.content,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget content;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(29, 0, 29, 0),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextTheme.onboardingTitle(context),
            ),
            const SizedBox(height: 35),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextTheme.onboardingBody(context),
            ),
            const SizedBox(height: 32),
            Expanded(child: content),
          ],
        ),
      );
}
