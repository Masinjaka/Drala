import 'package:budgets/core/theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/features/guest/data/guest_category_store.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
      'a saved category survives abandoning an unnamed envelope and can be reused',
      (tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    addTearDown(guest.dispose);
    await guest.start();
    await guest.repositories.wallets.add(const AddWalletInput(
        name: 'Cash', initialBalance: 1000, setAsDefault: true));
    await tester.pumpWidget(ProviderScope(
      overrides: [guestSessionProvider.overrideWithValue(guest)],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: EnvelopePage(repository: guest.repositories.envelopeRepository),
      ),
    ));
    await tester.pumpAndSettle();
    await _add(tester);
    await tester.enterText(find.byType(TextFormField).first, '100');
    await _categories(tester);
    await tester.tap(find.byKey(const Key('category-create')));
    await tester.pumpAndSettle();
    final categoryName = find.descendant(
        of: find.byType(CategoryEditorSheet),
        matching: find.byType(TextFormField));
    await tester.enterText(categoryName, 'Internet');
    await tester.ensureVisible(find.byKey(const Key('save-transaction')));
    await tester.tap(find.byKey(const Key('save-transaction')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('category-done')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();
    expect(find.text('Enter an envelope name.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('close-transaction-sheet')));
    await tester.pumpAndSettle();
    final saved = await GuestCategoryStore(database, guest.userId).categories();
    expect(saved.single.name, 'Internet');
    expect(saved.single.emoji, '😀');
    expect(await guest.repositories.envelopes.envelopesForMonth(DateTime.now()),
        isEmpty);
    await _add(tester);
    await tester.enterText(find.byType(TextFormField).first, '100');
    await tester.enterText(find.byType(TextFormField).at(1), 'Internet budget');
    await _categories(tester);
    final category = find.byKey(ValueKey('category-${saved.single.id}'));
    expect(category, findsOneWidget);
    await tester.tap(category);
    await tester.tap(find.byKey(const Key('category-done')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();
    final envelopes =
        await guest.repositories.envelopes.envelopesForMonth(DateTime.now());
    expect(envelopes.single.name, 'Internet budget');
    expect(envelopes.single.categoryId, saved.single.id);
    expect((await GuestCategoryStore(database, guest.userId).categories()),
        hasLength(1));
  });
}

Future<void> _add(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Add envelope'));
  await tester.pumpAndSettle();
}

Future<void> _categories(WidgetTester tester) async {
  await tester
      .ensureVisible(find.byKey(const Key('transaction-category-field')));
  await tester.tap(find.byKey(const Key('transaction-category-field')));
  await tester.pumpAndSettle();
}
