import 'package:budgets/features/auth/domain/providers/auth_providers.dart';
import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';
import 'package:budgets/core/legal/legal_document_launcher.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/auth/presentation/widgets/auth_header.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/features/auth/domain/models/password_validation.dart';
import 'package:budgets/features/auth/presentation/widgets/legal_consent_checkbox.dart';
import 'package:budgets/features/auth/presentation/widgets/sign_up_password_fields.dart';
import 'package:budgets/features/auth/presentation/widgets/sign_up_submit_bar.dart';
import 'package:budgets/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({
    this.legalLauncher = const UrlLegalDocumentLauncher(),
    super.key,
  });

  final LegalDocumentLauncher legalLauncher;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<SignUpPasswordFieldsState> _passwordFieldsKey = GlobalKey();
  bool _isLoading = false;
  bool _hasAcceptedLegalTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: _buildForm(context))),
      bottomNavigationBar: SignUpSubmitBar(
        isLoading: _isLoading,
        isEnabled: _hasAcceptedLegalTerms,
        onPressed: _submit,
      ),
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
                        ? 'Sign up'
                        : context.l10n.authSignUp,
                    onBack: () => context.canPop()
                        ? context.pop()
                        : context.go('/getting-started'),
                  ),
                  AuthTextField(
                    title: Text(
                      context.l10n.username,
                      textAlign: TextAlign.left,
                      style: AppTextTheme.authBody(context),
                    ),
                    hint: 'John',
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    validator: {
                      'type': 'required',
                      'error': context.l10n.username
                    },
                  ),
                  const SizedBox(height: 28),
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
                  SignUpPasswordFields(
                    key: _passwordFieldsKey,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                  const SizedBox(height: 28),
                  LegalConsentCheckbox(
                    value: _hasAcceptedLegalTerms,
                    launcher: widget.legalLauncher,
                    onChanged: (value) {
                      setState(() => _hasAcceptedLegalTerms = value);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!PasswordValidation(_passwordController.text).isSatisfied) {
      _passwordFieldsKey.currentState?.focusPassword();
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      showInfoToast(context, context.l10n.passwordsDoNotMatch);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(authControllerProvider.notifier).signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            username: _usernameController.text.trim(),
          );
      if (!mounted) return;
      final hasSession = await ref.read(authRepositoryProvider).hasSession();
      if (!mounted) return;
      if (hasSession) {
        context.go('/onboarding');
      } else {
        showInfoToast(context, context.l10n.authConfirmEmail);
        context.go('/login');
      }
    } catch (error, stackTrace) {
      debugPrint('[SignUpPage] signUp submission error: $error');
      debugPrint('[SignUpPage] signUp submission stackTrace: $stackTrace');
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
