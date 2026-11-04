part of 'navigation_page.dart';

class _TabConfig {
  const _TabConfig({
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
  });

  final String label;
  final FaIconData selectedIcon;
  final FaIconData unselectedIcon;
}
