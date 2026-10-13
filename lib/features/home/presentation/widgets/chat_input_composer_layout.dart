import 'package:flutter/material.dart';

class ChatInputComposerLayout extends StatelessWidget {
  const ChatInputComposerLayout({
    required this.isExpanded,
    required this.textInput,
    required this.addButton,
    required this.sendButton,
    super.key,
  });

  final bool isExpanded;
  final Widget textInput;
  final Widget addButton;
  final Widget sendButton;

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) {
      return SizedBox(
        height: 48,
        child: Row(
          children: [
            addButton,
            Expanded(
              child: Transform.translate(
                offset: const Offset(-8, 0),
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
          height: 48,
          child: Row(
            children: [addButton, const Spacer(), sendButton],
          ),
        ),
      ],
    );
  }
}
