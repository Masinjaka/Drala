import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'setup_grid_choice.dart';
import 'setup_wallet_icon.dart';

class SetupWalletChoices extends StatelessWidget {
  const SetupWalletChoices(
      {required this.language,
      required this.selected,
      required this.onChanged,
      super.key});
  final String language;
  final Set<String> selected;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    final l = lookupAppLocalizations(Locale(language));
    final choices = <String, String>{
      'cash': l.setupCash,
      'bank': l.setupBank,
      'mobile': l.setupMobile
    }.entries.toList();
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: LayoutBuilder(builder: (context, constraints) {
        final width = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var index = 0; index < choices.length; index++)
              SizedBox(
                width: width,
                child: SetupGridChoice(
                  title: choices[index].value,
                  selected: selected.contains(choices[index].key),
                  leading: SetupWalletIcon(kind: choices[index].key),
                  onTap: () => onChanged(choices[index].key),
                ).animate(delay: (50 * index).ms).fade(duration: 200.ms).slideY(
                      begin: 0.5,
                      duration: 200.ms,
                      curve: Curves.easeOut,
                    ),
              ),
          ],
        );
      }),
    );
  }
}
