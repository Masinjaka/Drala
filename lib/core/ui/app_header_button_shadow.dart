import 'package:flutter/material.dart';
import 'app_button_theme.dart';
import 'app_header_scope.dart';
import 'app_header_theme.dart';

class AppHeaderButtonShadow extends StatelessWidget {
  const AppHeaderButtonShadow({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => !AppHeaderScope.contains(context)
      ? child
      : DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: AppButtonTheme.borderRadius,
              boxShadow: AppHeaderTheme.buttonShadows(context)),
          child: child);
}
