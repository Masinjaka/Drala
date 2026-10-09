import 'package:budgets/core/legal/legal_document_launcher.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LegalConsentText extends StatefulWidget {
  const LegalConsentText({required this.launcher, super.key});
  final LegalDocumentLauncher launcher;

  @override
  State<LegalConsentText> createState() => _LegalConsentTextState();
}

class _LegalConsentTextState extends State<LegalConsentText> {
  late final TapGestureRecognizer _terms;
  late final TapGestureRecognizer _privacy;

  @override
  void initState() {
    super.initState();
    _terms = TapGestureRecognizer()
      ..onTap = () => _open(widget.launcher.openTermsAndConditions);
    _privacy = TapGestureRecognizer()
      ..onTap = () => _open(widget.launcher.openPrivacyPolicy);
  }

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  Future<void> _open(Future<void> Function() open) async {
    try {
      await open();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final linkStyle = AppTextTheme.legalLink(context);
    return Text.rich(
      TextSpan(children: [
        TextSpan(text: l.legalConsentPrefix),
        TextSpan(
            text: l.termsAndConditions,
            style: linkStyle,
            recognizer: _terms,
            mouseCursor: SystemMouseCursors.click),
        TextSpan(text: l.legalConsentConnector),
        TextSpan(
            text: l.privacyPolicy,
            style: linkStyle,
            recognizer: _privacy,
            mouseCursor: SystemMouseCursors.click),
        const TextSpan(text: '.'),
      ]),
      key: const Key('legal-consent-text'),
      style: AppTextTheme.authLabel(context),
    );
  }
}
