import 'package:flutter/material.dart';

import 'setup_language_choices.dart';
import 'setup_preset_choices.dart';
import 'setup_wallet_choices.dart';

class SetupChoiceContent extends StatelessWidget {
  const SetupChoiceContent({
    required this.step,
    required this.language,
    required this.categories,
    required this.wallets,
    required this.onLanguageChanged,
    required this.onCategoryChanged,
    required this.onWalletChanged,
    super.key,
  });

  final int step;
  final String language;
  final Set<String> categories;
  final Set<String> wallets;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onWalletChanged;

  @override
  Widget build(BuildContext context) => switch (step) {
        2 => SetupLanguageChoices(
            selected: language,
            onChanged: onLanguageChanged,
          ),
        4 => SetupPresetChoices(
            language: language,
            selected: categories,
            onChanged: onCategoryChanged,
          ),
        5 => SetupWalletChoices(
            language: language,
            selected: wallets,
            onChanged: onWalletChanged,
          ),
        _ => const SizedBox.shrink(),
      };
}
