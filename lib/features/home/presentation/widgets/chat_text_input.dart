import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';

import 'chat_typing_hint.dart';

class ChatTextInput extends StatelessWidget {
  const ChatTextInput({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.hints,
    required this.cursorColor,
    required this.hintColor,
    this.compact = false,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final List<String> hints;
  final Color cursorColor;
  final Color hintColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputStyle = compact
        ? AppActivitiesTheme.composerText(context)
        : theme.textTheme.bodyLarge!.copyWith(
            height: 1.35,
          );
    final hintStyle = compact
        ? AppActivitiesTheme.composerHint(context)
        : inputStyle.copyWith(
            color: hintColor.withValues(alpha: 0.78),
          );
    return ListenableBuilder(
      listenable: focusNode,
      builder: (context, _) => Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (controller.text.isEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ChatTypingHint(
                      suggestions: focusNode.hasFocus
                          ? [context.l10n.startTyping]
                          : hints,
                      animate: enabled && !focusNode.hasFocus,
                      style: hintStyle,
                    ),
                  ),
                ),
              ),
            ),
          TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            minLines: 1,
            maxLines: 4,
            style: inputStyle,
            cursorColor: cursorColor,
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            textInputAction: TextInputAction.newline,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
        ],
      ),
    );
  }
}
