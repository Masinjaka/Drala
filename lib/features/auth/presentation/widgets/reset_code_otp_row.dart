import 'package:budgets/core/ui/app_auth_theme.dart';
import 'package:budgets/core/forms/validated_selection.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetCodeOtpRow extends StatelessWidget {
  const ResetCodeOtpRow({
    required this.controllers,
    required this.focusNodes,
    super.key,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListenableBuilder(
        listenable: Listenable.merge(controllers),
        builder: (_, __) => ValidatedSelection(
            value: controllers.map((c) => c.text).join(),
            validator: () => RegExp(r'^\d{6}$')
                    .hasMatch(controllers.map((c) => c.text).join())
                ? null
                : context.l10n.authEnterSixDigitCode,
            child: Row(
              children: [
                for (var index = 0; index < controllers.length; index++) ...[
                  if (index > 0) const SizedBox(width: AppAuthTheme.otpGap),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: AppAuthTheme.otpAspectRatio,
                      child: TextFormField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        maxLength: 1,
                        style: AppAuthTheme.otpDigit(context),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          filled: true,
                          fillColor: colors.surfaceContainer,
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: _border(colors.surfaceContainer),
                          focusedBorder: _border(colors.primary),
                        ),
                        onChanged: (value) => _moveFocus(value, index),
                      ),
                    ),
                  ),
                ],
              ],
            )));
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: AppAuthTheme.otpBorderRadius,
        borderSide: BorderSide(color: color),
      );

  void _moveFocus(String value, int index) {
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }
}
