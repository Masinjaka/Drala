import 'package:budgets/core/ui/app_button_skeleton.dart';
import 'package:budgets/core/ui/app_header_button_shadow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'app_finance_surface_theme.dart';

class AppDeleteButton extends StatelessWidget {
  const AppDeleteButton(
      {required this.onPressed,
      required this.tooltip,
      this.busy = false,
      super.key});
  final VoidCallback? onPressed;
  final String tooltip;
  final bool busy;

  @override
  Widget build(BuildContext context) => busy
      ? const AppButtonSkeleton.icon()
      : AppHeaderButtonShadow(
          child: IconButton.filledTonal(
          onPressed: onPressed,
          tooltip: tooltip,
          style: AppFinanceSurfaceTheme.headerButton(context).copyWith(
            foregroundColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.disabled)
                    ? null
                    : AppFinanceSurfaceTheme.destructive(context)),
          ),
          icon: const FaIcon(FontAwesomeIcons.trashCan, size: 20),
        ));
}
