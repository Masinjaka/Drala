import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetupGridChoice extends StatefulWidget {
  const SetupGridChoice({
    required this.title,
    required this.selected,
    required this.onTap,
    required this.leading,
    this.height = 40,
    super.key,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final Widget leading;
  final double height;

  @override
  State<SetupGridChoice> createState() => _SetupGridChoiceState();
}

class _SetupGridChoiceState extends State<SetupGridChoice>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    reverseDuration: const Duration(milliseconds: 110),
  );
  late final Animation<double> _scale = Tween(begin: 1.0, end: 0.94).animate(
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: _controller.reverse,
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: Semantics(
          selected: widget.selected,
          button: true,
          child: Material(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: widget.height),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.leading,
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.title,
                        softWrap: true,
                        style: AppTextTheme.onboardingLabel(context),
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOutBack,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      ),
                      child: Icon(
                        widget.selected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        key: ValueKey(widget.selected),
                        size: 18,
                        color: widget.selected
                            ? AppTheme.homeBanner
                            : colors.onSurfaceVariant,
                      ),
                    ),
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
