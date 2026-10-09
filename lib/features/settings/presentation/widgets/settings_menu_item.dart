import 'package:flutter/material.dart';

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 51,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Row(
            children: [
              Icon(icon, size: 19),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 28,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
