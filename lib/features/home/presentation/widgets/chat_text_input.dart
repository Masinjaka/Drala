import 'package:flutter/material.dart';

class ChatTextInput extends StatelessWidget {
  const ChatTextInput({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.hint,
    required this.cursorColor,
    required this.hintColor,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final String hint;
  final Color cursorColor;
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (controller.text.isEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: _transition,
                  layoutBuilder: (current, previous) => Stack(
                    alignment: Alignment.centerLeft,
                    children: [...previous, if (current != null) current],
                  ),
                  child: Text(
                    hint,
                    key: ValueKey(hint),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: hintColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
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
          style: const TextStyle(fontSize: 12, height: 1),
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
    );
  }

  Widget _transition(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final leaving = animation.status == AnimationStatus.reverse;
        final offset = leaving ? animation.value - 1 : 1 - animation.value;
        return Opacity(
          opacity: animation.value,
          child: FractionalTranslation(
            translation: Offset(0, offset),
            child: child,
          ),
        );
      },
    );
  }
}
