import 'package:budgets/core/ui/detail_page_shell.dart';
import 'package:flutter/material.dart';

class SettingsPageShell extends StatelessWidget {
  const SettingsPageShell({
    required this.title,
    required this.child,
    this.bottomNavigationBar,
    this.maxWidth = 520,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? bottomNavigationBar;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return DetailPageShell(
        title: title,
        maxWidth: maxWidth,
        bottomNavigationBar: bottomNavigationBar,
        child: child);
  }
}
