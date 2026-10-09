import 'package:budgets/features/settings/presentation/pages/setting_page.dart';
import 'package:flutter/material.dart';

class SettingsWithBackPage extends StatelessWidget {
  const SettingsWithBackPage({this.onDataDeleted, super.key});
  final VoidCallback? onDataDeleted;
  @override
  Widget build(BuildContext context) =>
      SettingPage(onDataDeleted: onDataDeleted);
}
