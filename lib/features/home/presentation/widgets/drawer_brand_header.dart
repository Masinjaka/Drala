import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/paths.dart';
import 'package:budgets/features/home/presentation/widgets/drawer_profile_button.dart';
import 'package:flutter/material.dart';

class DrawerBrandHeader extends StatelessWidget {
  const DrawerBrandHeader({required this.onProfilePressed, super.key});

  final Future<void> Function() onProfilePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              AppPaths.logo,
              key: const Key('drawer-app-icon'),
              width: 38,
              height: 38,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 11),
          Text(
            'Drala',
            key: const Key('drawer-app-title'),
            style: AppTextStyle(AppTextRole.pageTitle,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.4),
          ),
          const Spacer(),
          DrawerProfileButton(onPressed: onProfilePressed),
        ],
      ),
    );
  }
}
