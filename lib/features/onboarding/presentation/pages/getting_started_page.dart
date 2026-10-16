import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/onboarding/domain/providers/onboarding_providers.dart';
import 'package:budgets/features/onboarding/presentation/widgets/category_explosion.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GettingStartedPage extends ConsumerStatefulWidget {
  const GettingStartedPage({super.key});

  @override
  ConsumerState<GettingStartedPage> createState() => _GettingStartedPageState();
}

class _GettingStartedPageState extends ConsumerState<GettingStartedPage> {
  bool _starting = false;

  Future<void> _start() async {
    if (_starting) return;
    setState(() => _starting = true);
    try {
      await ref.read(guestSessionProvider)!.start();
      ref.invalidate(onboardingRepositoryProvider);
      ref.invalidate(onboardingPresetsProvider);
      if (mounted) context.go('/onboarding');
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(29, 20, 29, 30),
              child: Column(
                children: [
                  const Expanded(
                    child: Align(
                      alignment: Alignment(0, -0.35),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CategoryExplosion(),
                      ),
                    ),
                  ),
                  Text(
                    l.guestWelcomeTitle,
                    textAlign: TextAlign.center,
                    style: AppTextTheme.onboardingTitle(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.guestWelcomeBody,
                    textAlign: TextAlign.center,
                    style: AppTextTheme.onboardingBody(context),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: l.guestGetStarted,
                    onPressed: _start,
                    isLoading: _starting,
                    height: 44,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  const SizedBox(height: 12),
                  CustomButton.text(
                    text: l.authSignIn,
                    onPressed: () => context.push('/login'),
                    height: 44,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
