import 'package:flutter/material.dart';

class PlanChoiceCard extends StatelessWidget {
  const PlanChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground =
        isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: .055),
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: foreground, size: 22),
              const SizedBox(height: 16),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
              ),
              Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? foreground
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
