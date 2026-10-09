import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';
import 'package:budgets/features/auth/presentation/widgets/auth_header.dart';
import 'package:budgets/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SizedBox.expand(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(29, 48, 29, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AuthHeader(
                            title: context.l10n.authForgotPassword,
                            onBack: () => context.canPop()
                                ? context.pop()
                                : context.go('/login'),
                          ),
                          Text(context.l10n.authResetInstruction,
                              style: AppTextTheme.authBody(context)),
                          const SizedBox(height: 28),
                          AuthTextField(
                            title: Text(context.l10n.authEmail,
                                style: AppTextTheme.authBody(context)),
                            hint: 'example@mail.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: {
                              'type': 'email',
                              'error': context.l10n.authEmail,
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(29, 0, 29, 30),
            child: CustomButton(
              text: context.l10n.send,
              height: 44,
              borderRadius: BorderRadius.circular(9),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              isLoading: _isLoading,
              onPressed: _submit,
            ),
          ),
        ),
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final email = _emailController.text.trim();
      await ref
          .read(authControllerProvider.notifier)
          .resetPassword(email: email);
      if (!mounted) return;
      showSuccessToast(context, context.l10n.authResetCodeSent);
      context.push('/verify-reset-code', extra: email);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
