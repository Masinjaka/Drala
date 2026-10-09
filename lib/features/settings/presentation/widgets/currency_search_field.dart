import 'package:flutter/material.dart';

class CurrencySearchField extends StatelessWidget {
  const CurrencySearchField({
    required this.controller,
    required this.hint,
    super.key,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        style: theme.textTheme.bodySmall,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip:
                        MaterialLocalizations.of(context).deleteButtonTooltip,
                    onPressed: controller.clear,
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainer,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
