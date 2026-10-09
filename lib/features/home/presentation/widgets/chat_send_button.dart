import 'package:budgets/features/home/presentation/widgets/chat_loading_dots.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_colors.dart';
import 'package:flutter/material.dart';

class ChatSendButton extends StatefulWidget {
  const ChatSendButton({
    required this.isBusy,
    required this.isManualEntry,
    required this.onPressed,
    required this.tooltip,
    required this.bottomPadding,
    super.key,
  });

  final bool isBusy;
  final bool isManualEntry;
  final VoidCallback? onPressed;
  final String tooltip;
  final double bottomPadding;

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
    final buttonSize = 40 - widget.bottomPadding;
    final theme = Theme.of(context);
    final background = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerLowest
        : HomeColors.banner;
    return SizedBox(
      width: 52,
      height: 40,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.bottomPadding),
          child: ScaleTransition(
            scale: _scale,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SizedBox.square(
                dimension: buttonSize,
                child: IconButton(
                  onPressed: widget.onPressed == null ? null : _handlePressed,
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    minimumSize: Size.square(buttonSize),
                    maximumSize: Size.square(buttonSize),
                    foregroundColor: AppTheme.homeBannerText,
                    disabledForegroundColor:
                        AppTheme.homeBannerText.withValues(alpha: .7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    child: widget.isBusy
                        ? const ChatLoadingDots(
                            key: ValueKey('chat-send-loading'),
                            color: AppTheme.homeBannerText,
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
                            size: 22,
                          ),
                  ),
                  tooltip: widget.tooltip,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
