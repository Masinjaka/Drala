import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:flutter/material.dart';

class DangerActionCard extends StatelessWidget {
  const DangerActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    required this.isLoading,
    required this.actionKey,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final Key actionKey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: actionKey,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: AppIconForeground.resolve(
                    context,
                    AppFinanceSurfaceTheme.destructive(context),
                  ),
                  size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppFinanceSurfaceTheme.destructive(context),
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(Icons.chevron_right_rounded, size: 27),
          ],
        ),
      ),
    );
  }
}
