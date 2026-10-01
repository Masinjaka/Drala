import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:budgets/features/home/presentation/widgets/erasing_typewriter_animated_text.dart';
import 'package:flutter/material.dart';

class ChatTypingHint extends StatelessWidget {
  const ChatTypingHint({
    required this.suggestions,
    required this.style,
    required this.animate,
    super.key,
  });

  final List<String> suggestions;
  final TextStyle style;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    if (!animate || MediaQuery.disableAnimationsOf(context)) {
      return Text(
        suggestions.first,
        key: const Key('chat-typing-hint-text'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }
    final animatedStyle = style.copyWith(
      fontSize: (style.fontSize ?? 14) - 1,
    );
    return DefaultTextStyle(
      style: style,
      child: AnimatedTextKit(
        key: ValueKey(Object.hashAll(suggestions)),
        animatedTexts: [
          for (final suggestion in suggestions)
            ErasingTypewriterAnimatedText(
              suggestion,
              textStyle: animatedStyle,
              cursorStyle: style,
            ),
        ],
        pause: const Duration(milliseconds: 350),
        repeatForever: true,
      ),
    );
  }
}
