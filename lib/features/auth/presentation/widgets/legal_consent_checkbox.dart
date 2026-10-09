import 'package:budgets/core/legal/legal_document_launcher.dart';
import 'legal_consent_text.dart';
import 'package:flutter/material.dart';

class LegalConsentCheckbox extends StatelessWidget {
  const LegalConsentCheckbox({
    required this.value,
    required this.onChanged,
    required this.launcher,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final LegalDocumentLauncher launcher;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          key: const Key('legal-consent-checkbox'),
          value: value,
          onChanged: (selected) => onChanged(selected ?? false),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 11),
            child: LegalConsentText(launcher: launcher),
          ),
        ),
      ],
    );
  }
}
