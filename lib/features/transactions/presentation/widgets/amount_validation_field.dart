import 'dart:math' as math;
import 'package:budgets/core/forms/submission_validation_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Keeps amount errors accessible without adding a visible error row.
class AmountValidationField extends FormField<String> {
  AmountValidationField({
    required String value,
    required String? Function() validator,
    required Widget child,
    required BuildContext context,
    super.key,
  }) : super(
          initialValue: value,
          autovalidateMode: SubmissionValidationScope.mode(context),
          validator: (_) => validator(),
          builder: (field) =>
              (field as _AmountValidationFieldState).feedback(child),
        );

  @override
  FormFieldState<String> createState() => _AmountValidationFieldState();
}

class _AmountValidationFieldState extends FormFieldState<String>
    with SingleTickerProviderStateMixin {
  late final _shake = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 360));

  @override
  void didUpdateWidget(covariant AmountValidationField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) didChange(widget.initialValue);
      });
    }
  }

  @override
  bool validate() {
    final valid = super.validate();
    if (!valid) {
      if (!MediaQuery.disableAnimationsOf(context)) _shake.forward(from: 0);
      SemanticsService.sendAnnouncement(
          View.of(context), errorText!, Directionality.of(context));
    }
    return valid;
  }

  Widget feedback(Widget child) => Semantics(
        key: const Key('amount-validation-feedback'),
        label: errorText,
        liveRegion: hasError,
        child: AnimatedBuilder(
          animation: _shake,
          child: child,
          builder: (context, child) => Transform.translate(
            key: const Key('amount-shake'),
            offset: Offset(
                MediaQuery.disableAnimationsOf(context)
                    ? 0
                    : math.sin(_shake.value * math.pi * 6) *
                        5 *
                        (1 - _shake.value),
                0),
            child: child,
          ),
        ),
      );

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }
}
