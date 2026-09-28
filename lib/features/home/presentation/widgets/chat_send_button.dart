import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:budgets/features/home/presentation/widgets/chat_loading_dots.dart';
import 'package:flutter/material.dart';

class ChatSendButton extends StatefulWidget {
  const ChatSendButton({
    required this.isBusy,
    required this.isManualEntry,
    required this.onPressed,
    required this.tooltip,
    super.key,
  });

  final bool isBusy;
  final bool isManualEntry;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  State<ChatSendButton> createState() => _ChatSendButtonState();
}

class _ChatSendButtonState extends State<ChatSendButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.06),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.06, end: 0.96),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.96, end: 1),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handlePressed() {
    _pressController.forward(from: 0);
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: ScaleTransition(
          scale: _scale,
          child: SizedBox.square(
            dimension: AppControlMetrics.iconButtonSize,
            child: IconButton.outlined(
              onPressed: widget.onPressed == null ? null : _handlePressed,
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: widget.isBusy
                    ? ChatLoadingDots(
                        key: const ValueKey('chat-send-loading'),
                        color: color,
                      )
                    : Icon(
                        widget.isManualEntry
                            ? Icons.edit_note_rounded
                            : Icons.arrow_upward_rounded,
                        key: ValueKey(
                          widget.isManualEntry
                              ? 'chat-send-manual'
                              : 'chat-send-arrow',
                        ),
                        size: AppControlMetrics.iconSize,
                      ),
              ),
              tooltip: widget.tooltip,
            ),
          ),
        ),
      ),
    );
  }
}
