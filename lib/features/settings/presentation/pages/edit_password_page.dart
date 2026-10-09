import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_editor_sheet.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_transaction_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPasswordPage extends ConsumerStatefulWidget {
  const EditPasswordPage({this.asSheet = false, super.key});

  final bool asSheet;

  static Future<void> show(BuildContext context) =>
      showTransactionFormSheet<void>(context,
          builder: (_) => const EditPasswordPage(asSheet: true));

  @override
  ConsumerState<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends ConsumerState<EditPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (_, next) {
      next.whenOrNull(error: (error, _) => showErrorToast(context, error));
    });
    final form = Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
        children: [
          _field(
            title: context.l10n.currentPassword,
            hint: context.l10n.enterCurrentPassword,
            controller: _currentController,
          ),
          const SizedBox(height: 20),
          _field(
            title: context.l10n.newPassword,
            hint: context.l10n.enterNewPassword,
            controller: _newController,
          ),
          const SizedBox(height: 20),
          _field(
            title: context.l10n.confirmPassword,
            hint: context.l10n.confirmNewPassword,
            controller: _confirmController,
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: context.l10n.save,
            height: 40,
            borderRadius: BorderRadius.circular(6),
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _save,
          ),
        ],
      ),
    );
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: widget.asSheet
          ? SettingsEditorSheet(title: context.l10n.changePassword, child: form)
          : SettingsPageShell(title: context.l10n.changePassword, child: form),
    );
  }

  SettingsTransactionField _field({
    required String title,
    required String hint,
    required TextEditingController controller,
  }) {
    return SettingsTransactionField(
      label: title,
      hint: hint,
      controller: controller,
      isPassword: true,
      validator: const {'type': 'password'},
    );
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_newController.text != _confirmController.text) {
      showInfoToast(context, context.l10n.passwordsDoNotMatch);
      return;
    }
    if (_currentController.text == _newController.text) {
      showInfoToast(context, context.l10n.passwordMustDiffer);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(authControllerProvider.notifier).changePassword(
            currentPassword: _currentController.text,
            newPassword: _newController.text,
          );
      if (!mounted) return;
      showSuccessToast(context, context.l10n.passwordUpdated);
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
