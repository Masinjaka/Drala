import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/app_setup_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_selection_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetupGridChoice extends StatefulWidget {
  const SetupGridChoice({
    required this.title,
    required this.selected,
    required this.onTap,
    required this.leading,
    this.height = 50,
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
          child: AppCardSurface(
            showShadow: false,
            color: AppSetupTheme.choiceBackground(context,
                selected: widget.selected),
            borderRadius: BorderRadius.all(AppSetupTheme.choiceRadius),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: widget.height),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.leading,
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.title,
                        softWrap: true,
                        style: AppTextTheme.setupLabel(context),
                      ),
                    ),
                    const SizedBox(width: 4),
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
