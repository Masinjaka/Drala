import 'package:budgets/features/onboarding/presentation/widgets/category_explosion.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({super.key});
  @override
  Widget build(BuildContext context) {
    final english = Localizations.localeOf(context).languageCode == 'en';
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
                  CustomButton(
                    text: english ? 'Create account' : context.l10n.authSignUp,
                    onPressed: () => context.push('/signup'),
                    height: 44,
                    borderRadius: BorderRadius.circular(9),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 15),
                  CustomButton.outlined(
                    text: english ? 'Login' : context.l10n.authSignIn,
                    onPressed: () => context.push('/login'),
                    height: 44,
                    borderRadius: BorderRadius.circular(9),
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
