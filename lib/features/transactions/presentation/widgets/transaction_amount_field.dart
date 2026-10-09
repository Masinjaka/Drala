import 'package:budgets/core/currency/currency_amount_input_formatter.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';

class TransactionAmountField extends StatelessWidget {
  const TransactionAmountField(
      {super.key, required this.controller, required this.currencyCode});
  final TextEditingController controller;
  final String currencyCode;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      IntrinsicWidth(
        child: TextFormField(
          key: const ValueKey('transaction-amount'),
          controller: controller,
          cursorColor: colors.onSurface,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: const [CurrencyAmountInputFormatter()],
          validator: (value) =>
              (value == null || value.trim().isEmpty) ? '' : null,
          style: AppTextTheme.amount(
            Theme.of(context).textTheme.headlineMedium!,
          ),
          decoration: const InputDecoration(
            hintText: '0',
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            constraints: BoxConstraints(minWidth: 42, maxWidth: 235),
          ),
        ),
      ),
      const SizedBox(width: 7),
      Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(currencyCode, style: Theme.of(context).textTheme.bodyLarge),
      ),
    ]);
  }
}
