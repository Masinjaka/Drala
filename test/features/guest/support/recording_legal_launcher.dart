import 'package:budgets/core/legal/legal_document_launcher.dart';

class RecordingLegalLauncher implements LegalDocumentLauncher {
  final opened = <String>[];

  @override
  Future<void> openTermsAndConditions() async => opened.add('terms');

  @override
  Future<void> openPrivacyPolicy() async => opened.add('privacy');
}
