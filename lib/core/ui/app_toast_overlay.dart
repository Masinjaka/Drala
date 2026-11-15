import 'dart:async';

import 'package:budgets/core/ui/app_toast_theme.dart';
import 'app_toast_placement.dart';
import 'package:budgets/core/ui/app_toast_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppToastOverlay extends StatefulWidget {
  const AppToastOverlay({
    required this.message,
    required this.type,
    required this.onDismissed,
    required this.onDisposed,
    this.sourceContext,
    this.displayDuration = const Duration(milliseconds: 3000),
    this.animationDuration = const Duration(milliseconds: 220),
    super.key,
  });

  final String message;
  final AppToastType type;
  final BuildContext? sourceContext;
  final VoidCallback onDismissed;
  final VoidCallback onDisposed;
  final Duration displayDuration;
  final Duration animationDuration;

  @override
  State<AppToastOverlay> createState() => _AppToastOverlayState();
}

class _AppToastOverlayState extends State<AppToastOverlay> {
  Timer? _dismissTimer;
  bool _isExiting = false;

  void _startDismissTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = Timer(widget.displayDuration, _dismiss);
  }

  void _dismiss() {
    if (!mounted || _isExiting) return;
    _dismissTimer?.cancel();
    setState(() => _isExiting = true);
  }

  void _finishDismissal(AnimationController _) {
    if (mounted) widget.onDismissed();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    widget.onDisposed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppToastPlacement(
        sourceContext: widget.sourceContext,
        child: _buildToast(context),
      );

  Widget _buildToast(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppToastTheme>() ??
        (theme.brightness == Brightness.dark
            ? AppToastTheme.dark
            : AppToastTheme.light);
    final accent = switch (widget.type) {
      AppToastType.success => colors.success,
      AppToastType.error => colors.error,
      AppToastType.info => colors.info,
    };
    final icon = switch (widget.type) {
      AppToastType.success => Icons.check_rounded,
      AppToastType.error => Icons.priority_high_rounded,
      AppToastType.info => Icons.info_rounded,
    };
    final toast = ClipPath(
      clipper: const ShapeBorderClipper(shape: AppToastTheme.shape),
      child: BackdropFilter(
        filter: AppToastTheme.blur,
        child: Material(
          type: MaterialType.transparency,
          child: Semantics(
            liveRegion: true,
            child: Container(
              key: const Key('app-toast'),
              constraints: const BoxConstraints(maxWidth: 520, minHeight: 44),
              padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 4, 4),
              decoration: ShapeDecoration(
                color: colors.tint(context),
                shape: AppToastTheme.shape.copyWith(
                  side: BorderSide(color: colors.border(context)),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 11,
                    backgroundColor: accent,
                    child: Icon(icon,
                        color: widget.type == AppToastType.error
                            ? colors.errorForeground
                            : colors.iconForeground,
                        size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: colors.messageStyle(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    key: const Key('app-toast-close'),
                    onPressed: _dismiss,
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    iconSize: 20,
                    constraints:
                        const BoxConstraints(minWidth: 44, minHeight: 44),
                    color: colors.foreground,
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (_isExiting) {
      return toast
          .animate(
              key: const Key('app-toast-exit'), onComplete: _finishDismissal)
          .fadeOut(duration: widget.animationDuration, curve: Curves.easeIn)
          .slideY(
            begin: 0,
            end: 1,
            duration: widget.animationDuration,
            curve: Curves.easeIn,
          );
    }

    return toast
        .animate(
            key: const Key('app-toast-enter'),
            onComplete: (_) => _startDismissTimer())
        .fadeIn(duration: widget.animationDuration, curve: Curves.easeOut)
        .slideY(
          begin: 1,
          end: 0,
          duration: widget.animationDuration,
          curve: Curves.easeOutCubic,
        );
  }
}
