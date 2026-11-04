import 'package:flutter/material.dart';

class SubmissionValidationScope extends InheritedWidget {
  const SubmissionValidationScope(
      {required this.submitted,
      required this.markSubmitted,
      required super.child,
      super.key});
  final bool submitted;
  final VoidCallback markSubmitted;
  static SubmissionValidationScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SubmissionValidationScope>();
  static AutovalidateMode mode(BuildContext context) {
    final scope = of(context);
    return scope == null || scope.submitted
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;
  }

  static void submit(BuildContext context, VoidCallback onSave) {
    of(context)?.markSubmitted();
    onSave();
  }

  @override
  bool updateShouldNotify(SubmissionValidationScope oldWidget) =>
      submitted != oldWidget.submitted;
}
