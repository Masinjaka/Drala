import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';
import 'package:budgets/features/auth/presentation/widgets/auth_header.dart';
import 'package:budgets/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:budgets/features/auth/presentation/widgets/reset_code_otp_row.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifyResetCodePage extends ConsumerStatefulWidget {
  const VerifyResetCodePage({super.key, required this.email});
  final String email;

  @override
  ConsumerState<VerifyResetCodePage> createState() =>
      _VerifyResetCodePageState();
}

class _VerifyResetCodePageState extends ConsumerState<VerifyResetCodePage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  String get _otpCode =>
      _otpControllers.map((controller) => controller.text).join();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _otpFocusNodes) {
      node.dispose();
    }
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
                            title: context.l10n.newPassword,
                            onBack: () => context.canPop()
                                ? context.pop()
                                : context.go('/reset-password'),
                          ),
                          Text(context.l10n.authCodeSentTo,
                              style: AppTextTheme.authBody(context)),
                          const SizedBox(height: 4),
                          Text(widget.email,
                              style: AppTextTheme.authBody(context)),
                          const SizedBox(height: 28),
                          Text(context.l10n.authVerificationCode,
                              style: AppTextTheme.authBody(context)),
                          const SizedBox(height: 6),
                          ResetCodeOtpRow(
                            controllers: _otpControllers,
                            focusNodes: _otpFocusNodes,
                          ),
                          const SizedBox(height: 28),
                          AuthTextField(
                            title: Text(context.l10n.newPassword,
                                style: AppTextTheme.authBody(context)),
                            hint: 'xxxxxxxx',
                            controller: _newPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            validator: const {'type': 'password'},
                          ),
                          const SizedBox(height: 28),
                          AuthTextField(
                            title: Text(context.l10n.confirmPassword,
                                style: AppTextTheme.authBody(context)),
                            hint: 'xxxxxxxx',
                            controller: _confirmPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            validator: const {'type': 'password'},
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
              text: context.l10n.authResetButton,
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
    if (_otpCode.length != 6) {
      showInfoToast(context, context.l10n.authEnterSixDigitCode);
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      showInfoToast(context, context.l10n.passwordsDoNotMatch);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(authControllerProvider.notifier).verifyOtpAndResetPassword(
            email: widget.email,
            otp: _otpCode,
            newPassword: _newPasswordController.text,
          );
      if (!mounted) return;
      showSuccessToast(context, context.l10n.authResetSuccess);
      context.go('/login');
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
