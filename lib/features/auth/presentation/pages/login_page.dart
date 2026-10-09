import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/auth/presentation/widgets/auth_header.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: _buildForm(context))),
      bottomNavigationBar: _buildBottomPart(),
    );
  }

  Widget _buildForm(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
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
                    title: Localizations.localeOf(context).languageCode == 'en'
                        ? 'Login'
                        : context.l10n.authSignIn,
                    onBack: () => context.canPop()
                        ? context.pop()
                        : context.go('/getting-started'),
                  ),
                  const SizedBox(height: 10),
                  AuthTextField(
                    title: Text(
                      context.l10n.authEmail,
                      textAlign: TextAlign.left,
                      style: AppTextTheme.authBody(context),
                    ),
                    hint: 'example@mail.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: {
                      'type': 'email',
                      'error': context.l10n.authEmail
                    },
                  ),
                  const SizedBox(height: 28),
                  AuthTextField(
                    title: Text(
                      context.l10n.authPassword,
                      textAlign: TextAlign.left,
                      style: AppTextTheme.authBody(context),
                    ),
                    hint: 'xxxxxxxx',
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    validator: {
                      'type': 'required',
                      'error': context.l10n.enterPassword
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton.text(
                      text: context.l10n.authForgotPassword,
                      width: 165,
                      height: 40,
                      textStyle: AppTextTheme.authBody(context),
                      onPressed: () => context.push('/reset-password'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPart() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(29, 0, 29, 30),
        child: CustomButton(
          text: Localizations.localeOf(context).languageCode == 'en'
              ? 'Login'
              : context.l10n.authSignIn,
          height: 44,
          borderRadius: BorderRadius.circular(9),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            setState(() => _isLoading = true);
            try {
              debugPrint('[LoginPage] Submit pressed - signIn started');
              await ref.read(authControllerProvider.notifier).signIn(
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                  );
              debugPrint('[LoginPage] signIn completed - navigating to /home');
              if (!mounted) return;
              context.go('/home');
            } catch (e, st) {
              debugPrint('[LoginPage] signIn submission error: $e');
              debugPrint('[LoginPage] signIn submission stackTrace: $st');
              if (mounted) showErrorToast(context, e);
            } finally {
              if (mounted) {
                setState(() => _isLoading = false);
              }
            }
          },
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
