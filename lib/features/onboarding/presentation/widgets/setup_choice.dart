import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_selection_indicator.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_setup_theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
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
    this.pill = false,
    this.centerTitle = false,
    super.key,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final double height;
  final bool pill;
  final bool centerTitle;

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
    final foreground = widget.pill
        ? AppSetupTheme.choiceForeground(context, selected: widget.selected)
        : AppTheme.onboardingChoiceForeground(context,
            selected: widget.selected);
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
          child: AppCardSurface(
            color: widget.pill
                ? AppSetupTheme.choiceBackground(context,
                    selected: widget.selected)
                : AppTheme.onboardingChoiceColor(
                    context,
                    selected: widget.selected,
                  ),
            showShadow: false,
            borderRadius: BorderRadius.all(AppSetupTheme.choiceRadius),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: widget.height,
              child: Padding(
                padding: EdgeInsets.only(
                  left: widget.pill && !widget.centerTitle ? 24 : 15,
                  right: widget.pill && !widget.centerTitle ? 16 : 15,
                ),
                child: Row(
                  children: [
                    if (widget.leading != null) ...[
                      widget.leading!,
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: widget.centerTitle
                            ? TextAlign.center
                            : TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: (widget.pill
                                ? AppTextTheme.setupLabel(context)
                                : AppTextTheme.onboardingLabel(context))
                            .copyWith(
                          color: foreground,
                        ),
                      ),
                    ),
                    if (widget.trailing != null) ...[
                      const SizedBox(width: 8),
                      DefaultTextStyle.merge(
                        style: (widget.pill
                                ? AppTextTheme.setupLabel(context)
                                : AppTextTheme.onboardingLabel(context))
                            .copyWith(
                          color: foreground,
                        ),
                        child: IconTheme(
                          data: IconThemeData(
                            color:
                                AppIconForeground.resolve(context, foreground),
                          ),
                          child: widget.trailing!,
                        ),
                      ),
                    ],
                    const SizedBox(width: 12),
                    SettingsSelectionIndicator(selected: widget.selected),
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
