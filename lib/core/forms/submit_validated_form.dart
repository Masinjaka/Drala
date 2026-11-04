import 'package:flutter/material.dart';
import 'submission_validation_scope.dart';

class SubmitValidatedForm extends StatefulWidget {
  const SubmitValidatedForm(
      {required this.formKey, required this.child, super.key});
  final GlobalKey<FormState> formKey;
  final Widget child;
  @override
  State<SubmitValidatedForm> createState() => _SubmitValidatedFormState();
}

class _SubmitValidatedFormState extends State<SubmitValidatedForm>
    with AutomaticKeepAliveClientMixin {
  bool _submitted = false;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SubmissionValidationScope(
        submitted: _submitted,
        markSubmitted: () {
          if (!_submitted) setState(() => _submitted = true);
        },
        child: Form(key: widget.formKey, child: widget.child));
  }
}
