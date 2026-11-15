import 'package:budgets/core/ui/app_empty_state_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EmptyStateInlineMessage extends StatefulWidget {
  const EmptyStateInlineMessage({
    required this.message,
    required this.actionLabel,
    required this.onPressed,
    required this.style,
    super.key,
  });

  final String Function(String) message;
  final String actionLabel;
  final VoidCallback onPressed;
  final TextStyle style;

  @override
  State<EmptyStateInlineMessage> createState() =>
      _EmptyStateInlineMessageState();
}

class _EmptyStateInlineMessageState extends State<EmptyStateInlineMessage> {
  static const _actionPlaceholder = '\uFFFC';
  late final _action = TapGestureRecognizer()..onTap = () => widget.onPressed();

  @override
  void dispose() {
    _action.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parts = widget.message(_actionPlaceholder).split(_actionPlaceholder);
    return SizedBox(
      width: 200,
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: parts.first),
          for (final part in parts.skip(1)) ...[
            TextSpan(
              text: widget.actionLabel,
              style: AppEmptyStateTheme.inlineLink(context),
              recognizer: _action,
              mouseCursor: SystemMouseCursors.click,
            ),
            TextSpan(text: part),
          ],
        ]),
        textAlign: TextAlign.center,
        style: widget.style,
      ),
    );
  }
}
