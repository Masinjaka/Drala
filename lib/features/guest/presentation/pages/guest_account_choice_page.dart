import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/app_button_theme.dart';
import 'package:budgets/core/ui/app_grid_background.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/onboarding/presentation/widgets/category_explosion.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GuestAccountChoicePage extends ConsumerWidget {
  const GuestAccountChoicePage({this.showGuestOption = true, super.key});

  final bool showGuestOption;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      body: AppGridBackground(
          child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: AppPageSpacing.insets(context,
                  top: AppHeaderMetrics.topPadding, bottom: 30),
              child: Column(
                children: [
                  if (!showGuestOption)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedSquareButton(
                        icon: Icons.arrow_back_rounded,
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ),
                  const Expanded(
                    child: Align(
                      alignment: Alignment(0, -0.35),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CategoryExplosion(compactLogo: true),
                      ),
                    ),
                  ),
                  if (showGuestOption) ...[
                    Text(
                      l.guestChoiceTitle,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.onboardingTitle(context),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l.guestChoiceBody,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.onboardingBody(context),
                    ),
                  ],
                  const SizedBox(height: 32),
                  if (showGuestOption) ...[
                    CustomButton(
                      text: l.guestContinue,
                      onPressed: () async {
                        await ref.read(guestSessionProvider)!.markChoiceSeen();
                        if (context.mounted) context.go('/home');
                      },
                      height: 44,
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (!showGuestOption) ...[
                    CustomButton(
                      text: l.authSignUp,
                      onPressed: () => context.push('/signup'),
                      height: 44,
                    ),
                    const SizedBox(height: 12),
                    CustomButton.text(
                      text: l.authSignIn,
                      foregroundColor: AppButtonTheme.textForeground(context),
                      onPressed: () => context.push('/login'),
                      height: 44,
                    ),
                  ] else ...[
                    CustomButton.outlined(
                      text: l.authSignUp,
                      onPressed: () => context.push('/signup'),
                      height: 44,
                    ),
                    const SizedBox(height: 12),
                    CustomButton.text(
                      text: l.authSignIn,
                      onPressed: () => context.push('/login'),
                      height: 44,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
