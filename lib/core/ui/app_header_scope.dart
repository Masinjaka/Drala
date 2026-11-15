import 'package:flutter/material.dart';

/// Limits header contrast styling to fixed controls, excluding sheets and body.
class AppHeaderScope extends InheritedWidget {
  const AppHeaderScope({required super.child, super.key});
  static bool contains(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppHeaderScope>() != null;
  @override
  bool updateShouldNotify(AppHeaderScope oldWidget) => false;
}
