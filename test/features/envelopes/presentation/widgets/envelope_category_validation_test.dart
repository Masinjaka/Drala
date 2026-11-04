import 'package:budgets/core/theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_picker.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/features/envelopes/presentation/widgets/add_envelope_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../categories/support/recording_categories.dart';

void main() {
  testWidgets('Internet saves with a selected icon and the default color',
      (tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final categories = RecordingCategories();
    await tester.pumpWidget(ProviderScope(
      overrides: [categoriesProvider.overrideWith(() => categories)],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                      onPressed: () => AddEnvelopeSheet.show(context,
                          categories: const [],
                          month: DateTime(2026, 10),
                          onSave: (_, __, ___, ____) async {}),
                      child: const Text('Open'),
                    ))),
      ),
    ));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester
        .ensureVisible(find.byKey(const Key('transaction-category-field')));
    await tester.tap(find.byKey(const Key('transaction-category-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('category-create')));
    await tester.pumpAndSettle();
    final editor = find.byType(CategoryEditorSheet);
    final name =
        find.descendant(of: editor, matching: find.byType(TextFormField));
    await tester.enterText(name, 'Internet');
    await tester.tap(find.byKey(const Key('category-icon-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key('category-icon-search')), 'Internet');
    await tester.pumpAndSettle();
    expect(find.byType(CategoryIconPicker), findsOneWidget);
    await tester.tap(find.byKey(const Key('category-icon-internet')));
    await tester.pumpAndSettle();
    final save = find.descendant(
        of: editor, matching: find.byKey(const Key('save-transaction')));
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(editor, findsNothing);
    expect(categories.saved.single.name, 'Internet');
    expect(categories.saved.single.emoji, isEmpty);
    expect(categories.saved.single.iconKey, 'internet');
    expect(categories.saved.single.color,
        AppTheme.primaryGreen.toARGB32().toRadixString(16).padLeft(8, '0'));
    expect(find.byKey(const Key('category-internet')), findsOneWidget);
    await tester.tap(find.byKey(const Key('category-done')));
    await tester.pumpAndSettle();
    expect(find.text('Internet'), findsOneWidget);
  });
}
