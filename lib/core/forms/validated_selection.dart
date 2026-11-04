import 'submission_validation_scope.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:flutter/material.dart';

class ValidatedSelection extends StatefulWidget {
  const ValidatedSelection(
      {required this.value, required this.child, this.validator, super.key});
  final Object? value;
  final Widget child;
  final String? Function()? validator;

  @override
  State<ValidatedSelection> createState() => _ValidatedSelectionState();
}

class _ValidatedSelectionState extends State<ValidatedSelection> {
  final _key = GlobalKey<FormFieldState<Object>>();

  @override
  void didUpdateWidget(covariant ValidatedSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _key.currentState?.didChange(widget.value);
      });
    }
  }

  @override
  Widget build(BuildContext context) => FormField<Object>(
        key: _key,
        initialValue: widget.value,
        autovalidateMode: SubmissionValidationScope.mode(context),
        validator: (_) => widget.validator != null
            ? widget.validator!()
            : FieldValidators.required(context, widget.value?.toString()),
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.child,
            if (field.errorText != null)
              Padding(
                  padding: const EdgeInsets.only(top: 6, left: 12),
                  child: Text(field.errorText!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error))),
          ],
        ),
      );
}
