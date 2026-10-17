import 'package:budgets/core/theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_delete_error_toast.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a localized category in use toast without raw errors',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showCategoryDeleteErrorToast(
              context,
              StateError('Category is in use.'),
            ),
            child: const Text('Delete'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Delete'));
    await tester.pump();
    expect(
      find.text(
          'The category cannot be deleted because it is currently in use.'),
      findsOneWidget,
    );
    expect(find.textContaining('Bad state'), findsNothing);
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  });
}
