import 'package:flutter/material.dart';

class TransactionSheetField extends StatelessWidget {
  const TransactionSheetField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          cursorColor: Theme.of(context).colorScheme.onSurface,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
