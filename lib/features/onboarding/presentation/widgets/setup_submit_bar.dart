import 'package:flutter/material.dart';

import 'setup_submit_button.dart';

class SetupSubmitBar extends StatelessWidget {
  const SetupSubmitBar({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    this.primary = true,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool primary;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(29, 12, 29, 30),
          child: SetupSubmitButton(
            isLoading: isLoading,
            onPressed: onPressed,
            text: text,
            primary: primary,
          ),
        ),
      );
}
