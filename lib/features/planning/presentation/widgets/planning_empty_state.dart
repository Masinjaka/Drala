import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlanningEmptyState extends StatelessWidget {
  final String? actionLabel;
  final VoidCallback? onAction;
  final String title;
  final String subtitle;
  final FaIconData icon;

  const PlanningEmptyState({
    super.key,
    this.actionLabel,
    this.onAction,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStatePhrase(
      title: title,
      subtitle: subtitle.isEmpty ? null : subtitle,
      icon: icon,
      action: onAction == null
          ? null
          : EmptyStateAction(label: actionLabel!, onPressed: onAction!),
    );
  }
}
