import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  for (final locale in [const Locale('en'), const Locale('fr')]) {
    testWidgets('auth connection failures show a localized toast in $locale',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                    onPressed: () => showErrorToast(
                        context,
                        AuthRetryableFetchException(
                            message: 'Failed host lookup')),
                    child: const Text('Fail refresh')))),
      ));
      await tester.tap(find.text('Fail refresh'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      final context = tester.element(find.text('Fail refresh'));
      final message = AppLocalizations.of(context).networkUnavailable;
      expect(find.text(message), findsOneWidget);
      expect(find.textContaining('Failed host lookup'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  }
}
