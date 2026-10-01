import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/widgets/custom_textfield.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
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
            Text(widget.title,
                style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text(widget.description,
                style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.25)),
            const SizedBox(height: 16),
            CustomTextField(
              key: const Key('danger-confirmation-field'),
              controller: _controller,
              title: Text(widget.instruction,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              hint: context.l10n.confirmation,
              fillColor: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(7),
              fontSize: AppTypography.body,
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.onSurface,
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      side: BorderSide(color: colors.onSurface),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                    ),
                    child: Text(context.l10n.cancel),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: FilledButton(
                    key: const Key('danger-confirm-button'),
                    onPressed: _matches ? _confirm : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.error,
                      foregroundColor: colors.onError,
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                    ),
                    child: Text(context.l10n.delete),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
