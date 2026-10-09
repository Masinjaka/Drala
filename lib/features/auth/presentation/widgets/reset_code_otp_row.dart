import 'package:budgets/core/ui/app_text_theme.dart';
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
    return Row(
      children: List.generate(controllers.length, (index) {
        return Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(right: index == controllers.length - 1 ? 0 : 8),
            child: TextFormField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: AppTextTheme.authBody(context),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                filled: true,
                fillColor: colors.surfaceContainer,
                contentPadding: const EdgeInsets.symmetric(vertical: 11.5),
                enabledBorder: _border(colors.surfaceContainer),
                focusedBorder: _border(colors.primary),
              ),
              onChanged: (value) => _moveFocus(value, index),
            ),
          ),
        );
      }),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
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
