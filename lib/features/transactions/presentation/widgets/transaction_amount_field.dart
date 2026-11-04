import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'dart:math' as math;
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/forms/validated_selection.dart';
import 'package:budgets/core/currency/currency_amount_input_formatter.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'amount_validation_field.dart';

class TransactionAmountField extends StatefulWidget {
  const TransactionAmountField(
      {super.key,
      required this.controller,
      required this.currencyCode,
      this.validator});
  final TextEditingController controller;
  final String currencyCode;
  final FormFieldValidator<String>? validator;

  @override
  State<TransactionAmountField> createState() => _TransactionAmountFieldState();
}

class _TransactionAmountFieldState extends State<TransactionAmountField> {
  final _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reference = FinanceSheetScope.of(context);
    final symbol = widget.currencyCode == 'MGA'
        ? 'Ar'
        : currencySymbolForCode(widget.currencyCode);
    final style = reference
        ? AppFinanceSurfaceTheme.amount(context)
        : AppTextTheme.amount(Theme.of(context).textTheme.headlineMedium!);
    final line = TextPainter(
        text: TextSpan(text: '0', style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context))
      ..layout();
    final height = line.height + 4;
    line.dispose();
    return ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          String? validate() => widget.validator != null
              ? widget.validator!(widget.controller.text)
              : FieldValidators.positiveAmount(context, widget.controller.text);
          final child = SizedBox(
              height: height,
              child: ListenableBuilder(
                listenable: Listenable.merge([widget.controller, _focus]),
                builder: (context, _) =>
                    LayoutBuilder(builder: (context, constraints) {
                  final theme = Theme.of(context);
                  final style = reference
                      ? AppFinanceSurfaceTheme.amount(context)
                      : AppTextTheme.amount(theme.textTheme.headlineMedium!);
                  final scale = MediaQuery.textScalerOf(context);
                  final direction = Directionality.of(context);
                  final text = widget.controller.text.isEmpty
                      ? (reference ? '0.00' : '0')
                      : widget.controller.text;
                  final amount = TextPainter(
                      text: TextSpan(text: text, style: style),
                      textDirection: direction,
                      textScaler: scale)
                    ..layout();
                  final currency = TextPainter(
                      text: TextSpan(
                          text: reference ? symbol : widget.currencyCode,
                          style: reference ? style : theme.textTheme.bodyLarge),
                      textDirection: direction,
                      textScaler: scale)
                    ..layout();
                  final available =
                      math.max(0.0, constraints.maxWidth - currency.width - 7);
                  final width = math.min(available,
                      math.min(235.0, math.max(42.0, amount.width + 2)));
                  final clipped = !_focus.hasFocus && amount.width > width;
                  amount.dispose();
                  currency.dispose();
                  return Row(
                      mainAxisAlignment: reference
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (reference) ...[
                          Text(symbol, style: style),
                          const SizedBox(width: 7)
                        ],
                        SizedBox(
                          width: width,
                          child:
                              Stack(alignment: Alignment.centerLeft, children: [
                            Opacity(
                              opacity: clipped ? 0 : 1,
                              child: TextFormField(
                                key: const ValueKey('transaction-amount'),
                                controller: widget.controller,
                                focusNode: _focus,
                                cursorColor:
                                    theme.textSelectionTheme.cursorColor,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: const [
                                  CurrencyAmountInputFormatter()
                                ],
                                style: style,
                                decoration: InputDecoration(
                                  hintText: reference ? '0.00' : '0',
                                  filled: false,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (clipped)
                              Positioned.fill(
                                  child: IgnorePointer(
                                      child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: ExcludeSemantics(
                                    child: Text(text,
                                        key: const Key('amount-overflow-label'),
                                        style: style,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                              ))),
                          ]),
                        ),
                        if (!reference) const SizedBox(width: 7),
                        if (!reference)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(widget.currencyCode,
                                style: theme.textTheme.bodyLarge),
                          ),
                      ]);
                }),
              ));
          return reference
              ? AmountValidationField(
                  value: widget.controller.text,
                  validator: validate,
                  context: context,
                  child: child)
              : ValidatedSelection(
                  value: widget.controller.text,
                  validator: validate,
                  child: child);
        });
  }
}
