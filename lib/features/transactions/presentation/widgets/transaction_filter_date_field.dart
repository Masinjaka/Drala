import 'package:flutter/material.dart';

class TransactionFilterDateField extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final VoidCallback onTap;

  const TransactionFilterDateField({
    super.key,
    required this.hint,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      readOnly: true,
      onTap: onTap,
      controller: controller,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent, width: 1.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.onSurface, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error, width: 1.8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error, width: 1.8),
        ),
        hintText: hint,
        suffixIcon: Icon(
          Icons.calendar_month_outlined,
          color: colors.onSurface,
        ),
      ),
    );
  }
}
