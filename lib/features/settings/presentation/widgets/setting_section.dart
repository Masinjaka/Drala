import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:flutter/material.dart';

class SettingSection extends StatelessWidget {
  const SettingSection(
      {super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const AppTextStyle(AppTextRole.sectionTitle),
        ),
        SizedBox(height: 8),
        Column(children: children)
      ],
    );
  }
}
