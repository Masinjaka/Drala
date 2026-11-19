import 'package:budgets/core/utils/animated_dialog.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatefulWidget {
  const LogoutConfirmationDialog({required this.onConfirm, super.key});
  final Future<void> Function() onConfirm;

  static Future<bool> show(BuildContext context,
          {required Future<void> Function() onConfirm}) async =>
      await showAnimatedDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => LogoutConfirmationDialog(onConfirm: onConfirm)) ??
      false;

  @override
  State<LogoutConfirmationDialog> createState() =>
      _LogoutConfirmationDialogState();
}

class _LogoutConfirmationDialogState extends State<LogoutConfirmationDialog> {
  bool _loading = false;

  Future<void> _confirm() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await widget.onConfirm();
      // Let the prepared guest destination render before removing the dialog.
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        setState(() => _loading = false);
        showErrorToast(context, error);
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
      canPop: !_loading,
      child: DeleteConfirmationDialog(
          title: context.l10n.logOut,
          message: context.l10n.logOutConfirmation,
          confirmText: context.l10n.logOut,
          cancelText: context.l10n.cancel,
          confirmKey: const Key('confirm-logout'),
          cancelKey: const Key('cancel-logout'),
          isLoading: _loading,
          onConfirm: _confirm,
          onCancel: () => Navigator.of(context).pop(false)));
}
