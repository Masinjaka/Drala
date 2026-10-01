import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ErasingTypewriterAnimatedText extends AnimatedText {
  ErasingTypewriterAnimatedText(
    String text, {
    required TextStyle textStyle,
    required this.cursorStyle,
    this.typeSpeed = const Duration(milliseconds: 55),
    this.eraseSpeed = const Duration(milliseconds: 30),
    this.idle = const Duration(milliseconds: 700),
  }) : super(
          text: text,
          textStyle: textStyle,
          duration: typeSpeed * text.characters.length +
              idle +
              eraseSpeed * text.characters.length,
        );

  final Duration typeSpeed;
  final Duration eraseSpeed;
  final Duration idle;
  final TextStyle cursorStyle;
  late Animation<double> _progress;

  int get _typingMicros => typeSpeed.inMicroseconds * textCharacters.length;
  int get _idleEndMicros => _typingMicros + idle.inMicroseconds;

  @override
  void initAnimation(AnimationController controller) {
    _progress = CurvedAnimation(parent: controller, curve: Curves.linear);
  }

  @override
  Widget completeText(BuildContext context) => _buildText(context, '', true);

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final elapsed = (duration.inMicroseconds * _progress.value).round();
    final length = textCharacters.length;
    late final int visibleCharacters;
    late final bool showCursor;
    if (elapsed < _typingMicros) {
      visibleCharacters =
          (elapsed / typeSpeed.inMicroseconds).ceil().clamp(0, length);
      showCursor = true;
    } else if (elapsed < _idleEndMicros) {
      visibleCharacters = length;
      showCursor = ((elapsed - _typingMicros) ~/ 300000).isEven;
    } else {
      final erased =
          ((elapsed - _idleEndMicros) / eraseSpeed.inMicroseconds).floor();
      visibleCharacters = (length - erased).clamp(0, length);
      showCursor = true;
    }
    return _buildText(
      context,
      textCharacters.take(visibleCharacters).toString(),
      showCursor,
    );
  }

  Widget _buildText(BuildContext context, String visible, bool showCursor) {
    final style = DefaultTextStyle.of(context).style.merge(textStyle);
    return RichText(
      key: const Key('chat-typing-hint-text'),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(style: style, children: [
        TextSpan(text: visible),
        TextSpan(
          text: '|',
          style: showCursor
              ? cursorStyle
              : cursorStyle.copyWith(color: Colors.transparent),
        ),
      ]),
    );
  }
}
