import 'package:flutter/material.dart';

import 'setup_choice.dart';
import 'setup_list_choice_entrance.dart';

class SetupLanguageChoices extends StatelessWidget {
  const SetupLanguageChoices({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  static const _languages = {
    'fr': 'Français',
    'en': 'English',
    'mg': 'Malagasy',
    'es': 'Spanish',
  };

  @override
  Widget build(BuildContext context) {
    final languages = _languages.entries.toList();
    return Column(
      children: [
        for (var index = 0; index < languages.length; index++) ...[
          SetupListChoiceEntrance(
            index: index,
            child: SetupChoice(
              title: languages[index].value,
              selected: selected == languages[index].key,
              onTap: () => onChanged(languages[index].key),
            ),
          ),
          if (index < languages.length - 1) const SizedBox(height: 18),
        ],
      ],
    );
  }
}
