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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.error, size: 21),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
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
