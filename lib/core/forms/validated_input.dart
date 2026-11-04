import 'package:budgets/core/forms/validated_selection.dart';
import 'package:flutter/material.dart';

class ValidatedInput extends StatelessWidget {
  const ValidatedInput(
      {required this.controller,
      required this.validator,
      required this.child,
      super.key});
  final TextEditingController controller;
  final String? Function(String) validator;
  final Widget child;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (_, __) => ValidatedSelection(
            value: controller.text,
            validator: () => validator(controller.text),
            child: child),
      );
}
