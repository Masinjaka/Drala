import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:budgets/core/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onPressed,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.isSquare = false,
    this.borderRadius,
    this.height,
    this.tooltip,
    this.textStyle,
    this.isLoading,
    super.key,
  })  : outlined = false,
        textOnly = false;

  const CustomButton.outlined({
    required this.text,
    required this.onPressed,
    this.width,
    this.foregroundColor,
    this.borderColor,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.isSquare = false,
    this.borderRadius,
    this.height,
    this.tooltip,
    this.textStyle,
    this.isLoading,
    super.key,
  })  : backgroundColor = null,
        outlined = true,
        textOnly = false;

  const CustomButton.icon({
    required this.icon,
    required this.onPressed,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.iconColor,
    this.iconSize,
    this.isSquare = false,
    this.borderColor,
    this.borderRadius,
    this.height,
    this.tooltip,
    this.textStyle,
    this.isLoading,
    super.key,
  })  : text = null,
        outlined = false,
        textOnly = false;

  const CustomButton.text({
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.foregroundColor,
    this.textStyle,
    super.key,
  })  : backgroundColor = null,
        borderColor = null,
        icon = null,
        iconColor = null,
        iconSize = null,
        isSquare = false,
        borderRadius = null,
        tooltip = null,
        isLoading = false,
        outlined = false,
        textOnly = true;

  final String? text;
  final double? width;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final bool isSquare;
  final BorderRadius? borderRadius;
  final double? height;
  final String? tooltip;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final bool outlined;
  final bool textOnly;

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(context);
    final button = SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppControlMetrics.height,
      child: FilledButton(
        onPressed: isLoading == true ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          disabledBackgroundColor:
              colors.background == Theme.of(context).colorScheme.primary
                  ? colors.background
                  : colors.background.withValues(alpha: .65),
          disabledForegroundColor: colors.foreground,
          side: _border(colors.foreground),
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.circular(isSquare ? 12 : 999),
          ),
          padding: icon != null && text == null
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
          textStyle: textStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
        child: isLoading == true
            ? SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.foreground,
                ),
              )
            : _content(context, colors.foreground),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }

  BorderSide _border(Color fallback) {
    if (textOnly) return BorderSide.none;
    if (borderColor != null) return BorderSide(color: borderColor!);
    return outlined ? BorderSide(color: fallback) : BorderSide.none;
  }

  ({Color background, Color foreground}) _resolveColors(
    BuildContext context,
  ) {
    final colors = Theme.of(context).colorScheme;
    if (textOnly) {
      return (
        background: colors.surface.withValues(alpha: 0),
        foreground: foregroundColor ?? colors.onSurface,
      );
    }
    if (outlined) {
      return (
        background: colors.surface.withValues(alpha: 0),
        foreground: foregroundColor ?? colors.onSurface,
      );
    }
    final background = backgroundColor ?? colors.inverseSurface;
    final defaultForeground = backgroundColor == null
        ? colors.onInverseSurface
        : background == colors.primary
            ? colors.onPrimary
            : AppTheme.foregroundFor(background);
    return (
      background: background,
      foreground: foregroundColor ?? defaultForeground,
    );
  }

  Widget _content(BuildContext context, Color color) {
    final label = Text(
      text ?? '',
      style: (textStyle ?? Theme.of(context).textTheme.bodyMedium)
          ?.copyWith(color: color),
    );
    if (icon == null) return label;
    if (text == null || text!.isEmpty) {
      return Icon(icon, color: iconColor ?? color, size: iconSize);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor ?? color, size: iconSize),
        const SizedBox(width: AppControlMetrics.contentGap),
        label,
      ],
    );
  }
}
