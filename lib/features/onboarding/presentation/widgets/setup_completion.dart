import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/features/onboarding/presentation/widgets/category_explosion.dart';
import 'package:flutter/material.dart';

import 'setup_delayed_content.dart';

class SetupCompletion extends StatelessWidget {
  const SetupCompletion({
    required this.title,
    required this.subtitle,
    required this.entranceDelay,
    super.key,
  });

  final String title;
  final String subtitle;
  final Duration entranceDelay;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 600;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 29),
          child: Column(
            children: [
              SizedBox(height: compact ? 21 : 29),
              Center(
                child: SetupDelayedContent(
                  delay: entranceDelay,
                  placeholder: const SizedBox(width: 320, height: 280),
                  child: const CategoryExplosion(compactLogo: true),
                ),
              ),
              SizedBox(height: compact ? 40 : 70),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.onboardingTitle(context),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.onboardingBody(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
