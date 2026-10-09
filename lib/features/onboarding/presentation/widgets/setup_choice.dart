import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetupChoice extends StatefulWidget {
  const SetupChoice({
    required this.title,
    required this.selected,
    required this.onTap,
    this.leading,
    this.trailing,
    this.height = 40,
    super.key,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final double height;

  @override
  State<SetupChoice> createState() => _SetupChoiceState();
}

class _SetupChoiceState extends State<SetupChoice>
    with SingleTickerProviderStateMixin {
  static const _quickTapHoldDuration = Duration(milliseconds: 30);
  bool _pressed = false;
  int _gestureId = 0;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 35),
    reverseDuration: const Duration(milliseconds: 60),
  );
  late final Animation<double> _scale = Tween(begin: 1.0, end: 0.98).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutCubic,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _press() {
    _pressed = true;
    _gestureId++;
    _controller.forward();
  }

  Future<void> _release() async {
    final gestureId = _gestureId;
    final completedBeforeRelease = _controller.isCompleted;
    _pressed = false;
    await _controller.forward();
    if (!completedBeforeRelease) {
      await Future<void>.delayed(_quickTapHoldDuration);
    }
    if (mounted && !_pressed && gestureId == _gestureId) {
      await _controller.reverse();
    }
  }

  void _cancelPress() {
    _pressed = false;
    _gestureId++;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final foreground =
        AppTheme.onboardingChoiceForeground(context, selected: widget.selected);
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _press(),
        onTapUp: (_) => _release(),
        onTapCancel: _cancelPress,
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: Semantics(
          selected: widget.selected,
          button: true,
          child: Material(
            color: AppTheme.onboardingChoiceColor(
              context,
              selected: widget.selected,
            ),
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: widget.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    if (widget.leading != null) ...[
                      widget.leading!,
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.onboardingLabel(context).copyWith(
                          color: foreground,
                        ),
                      ),
                    ),
                    if (widget.trailing != null) ...[
                      const SizedBox(width: 8),
                      DefaultTextStyle.merge(
                        style: AppTextTheme.onboardingLabel(context).copyWith(
                          color: foreground,
                        ),
                        child: IconTheme(
                          data: IconThemeData(color: foreground),
                          child: widget.trailing!,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
