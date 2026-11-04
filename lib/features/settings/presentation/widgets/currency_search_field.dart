import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_text_theme.dart';

class CurrencySearchField extends StatelessWidget {
  const CurrencySearchField({
    required this.controller,
    required this.hint,
    this.onboarding = false,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final bool onboarding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        style: onboarding
            ? AppTextTheme.setupLabel(context)
            : theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          constraints:
              onboarding ? const BoxConstraints.tightFor(height: 50) : null,
          hintText: hint,
          hintStyle: (onboarding
                  ? AppTextTheme.setupBody(context)
                  : theme.textTheme.bodyLarge)
              ?.copyWith(
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
          fillColor: theme.colorScheme.surfaceContainerLowest,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
