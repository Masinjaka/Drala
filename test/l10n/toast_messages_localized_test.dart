import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Legacy screens that are no longer reachable from the app.
const _legacy = {
  'lib/features/auth/presentation/pages/upload_profile_photo_page.dart',
  'lib/features/planning/presentation/widgets/add_goal_bottom_sheet_save_goal.dart',
  'lib/features/planning/presentation/widgets/goal_list_item_show_add_amount_form.dart',
  'lib/features/stats/presentation/modules/authentication_utils.dart',
  'lib/features/transactions/presentation/modules/transaction_module.dart',
};

final _toastCall = RegExp(r'show(App|Success|Info)Toast\(');
/// A complete single- or double-quoted string literal.
final _stringLiteral =
    RegExp(r"'(?:[^'\\]|\\.)*'" r'|"(?:[^"\\]|\\.)*"');
final _words = RegExp(r'[A-Za-zÀ-ÿ]{2}');

/// Returns the argument text of the call starting at [start].
String _arguments(String source, int start) {
  var depth = 1;
  var index = start;
  while (depth > 0 && index < source.length) {
    final char = source[index++];
    if (char == '(') depth++;
    if (char == ')') depth--;
  }
  return source.substring(start, index - 1);
}

void main() {
  test('toast messages come from the localization files', () {
    final offenders = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => !file.path.contains('/l10n/generated/'))
        .where((file) => !_legacy.contains(file.path));
    for (final file in files) {
      final source = file.readAsStringSync();
      for (final match in _toastCall.allMatches(source)) {
        final arguments = _arguments(source, match.end);
        // Drop comments and ${...} interpolations so only fixed text is checked.
        final fixedText = arguments
            .replaceAll(RegExp(r'//[^\n]*'), '')
            .replaceAll(RegExp(r'\$\{[^}]*\}'), '')
            .replaceAll(RegExp(r'\$\w+'), '');
        final hasText = _stringLiteral
            .allMatches(fixedText)
            .any((literal) => _words.hasMatch(literal.group(0)!));
        if (hasText) {
          final line = source.substring(0, match.start).split('\n').length;
          offenders.add('${file.path}:$line');
        }
      }
    }
    expect(offenders, isEmpty,
        reason: 'Use context.l10n for toast text so it follows the language.');
  });
}
