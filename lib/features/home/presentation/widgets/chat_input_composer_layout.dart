import 'package:flutter/material.dart';

class ChatInputComposerLayout extends StatelessWidget {
  const ChatInputComposerLayout({
    required this.isExpanded,
    this.compact = false,
    required this.textInput,
    required this.addButton,
    required this.sendButton,
    super.key,
  });

  final bool isExpanded;
  final bool compact;
  final Widget textInput;
  final Widget addButton;
  final Widget sendButton;

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) {
      return SizedBox(
        height: compact ? 46 : 48,
        child: Row(
          children: [
            addButton,
            Expanded(
              child: Transform.translate(
                offset: Offset(compact ? 0 : -8, 0),
                child: textInput,
              ),
            ),
            sendButton,
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 37),
            child: textInput,
          ),
        ),
        SizedBox(
          height: compact ? 46 : 48,
          child: Row(
            children: [addButton, const Spacer(), sendButton],
          ),
        ),
      ],
    );
  }
}
