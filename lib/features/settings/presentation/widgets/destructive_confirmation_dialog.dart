import 'package:budgets/features/settings/presentation/widgets/settings_transaction_field.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class DestructiveConfirmationDialog extends StatefulWidget {
  const DestructiveConfirmationDialog({
    required this.title,
    required this.description,
    required this.expectedConfirmation,
    required this.instruction,
    super.key,
  });

  final String title;
  final String description;
  final String expectedConfirmation;
  final String instruction;

  @override
  State<DestructiveConfirmationDialog> createState() =>
      _DestructiveConfirmationDialogState();
}

class _DestructiveConfirmationDialogState
    extends State<DestructiveConfirmationDialog> {
  final _controller = TextEditingController();
  var _matches = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateMatch);
  }

  void _updateMatch() {
    final matches = _controller.text.trim() == widget.expectedConfirmation;
    if (matches != _matches) setState(() => _matches = matches);
  }

  void _confirm() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  void dispose() {
    _controller.removeListener(_updateMatch);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 29),
      backgroundColor: colors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Text(widget.description,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            SettingsTransactionField(
              key: const Key('danger-confirmation-field'),
              controller: _controller,
              label: widget.instruction,
              hint: context.l10n.confirmation,
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: CustomButton.outlined(
                  text: context.l10n.cancel,
                  onPressed: () => Navigator.pop(context),
                  height: 40,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  key: const Key('danger-confirm-button'),
                  text: context.l10n.delete,
                  onPressed: _matches ? _confirm : null,
                  height: 40,
                  backgroundColor: colors.error,
                  foregroundColor: colors.onError,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
