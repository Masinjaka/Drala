import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/transactions/domain/model/transaction_model.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_detail_bottom_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestCurrencyController extends CurrencyController {
  @override
  Future<CurrencyState> build() async => const CurrencyState(
        code: 'USD',
        baseCode: 'MGA',
        rates: {'USD': 1},
      );
}

class _TestCategories extends Categories {
  @override
  Future<List<Category>> build() async => [
        Category(
          id: 'food',
          name: 'Food & Drinks',
          emoji: '🍔',
          transactionType: TransactionType.expense,
        ),
        Category(
          id: 'utility',
          name: 'Utility',
          emoji: '🔦',
          transactionType: TransactionType.expense,
        ),
      ];
}

void main() {
  final food = Category(
    id: 'food',
    name: 'Food & Drinks',
    emoji: '🍔',
    transactionType: TransactionType.expense,
  );
  final transaction = TransactionModel(
    id: 'transaction-id',
    title: 'Food',
    description: 'Bought food for my sweet family',
    amount: 3.99,
    category: food,
    transactionType: TransactionType.expense,
  );

  Future<void> pumpSheet(WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currencyControllerProvider.overrideWith(_TestCurrencyController.new),
          categoriesProvider.overrideWith(_TestCategories.new),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(412, 917),
              padding: EdgeInsets.only(bottom: 24),
            ),
            child: Scaffold(
              body: TransactionDetailBottomSheet(transaction: transaction),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
      'uses the full-width reference surface and keeps actions reachable',
      (tester) async {
    await pumpSheet(tester);
    final surface = find.byKey(const ValueKey('transaction-sheet-surface'));
    final rect = tester.getRect(surface);
    expect(rect.left, 0);
    expect(rect.width, 412);
    expect(rect.bottom, 917);
    expect(rect.height, closeTo(917 * .86, .1));
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Bought food for my sweet family'), findsNothing);
    expect(find.byType(TextFormField), findsNWidgets(2));
    final material = tester.widget<Material>(surface);
    expect(material.borderRadius, AppFinanceSurfaceTheme.sheetRadius);
    expect(material.color,
        AppFinanceSurfaceTheme.background(tester.element(surface)));
    expect(find.byKey(const Key('save-transaction')).hitTestable(),
        findsOneWidget);
    final gesture = await tester.startGesture(const Offset(206, 500));
    await gesture.moveBy(const Offset(0, -100));
    await tester.pump();
    expect(tester.getRect(surface), rect);
    await gesture.up();
  });

  testWidgets('category field animates to the picker in the same sheet',
      (tester) async {
    await pumpSheet(tester);

    await tester.tap(
      find.byKey(const ValueKey('transaction-category-field')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('category-done')), findsNothing);
    expect(find.byKey(const ValueKey('category-search')), findsOneWidget);
    expect(find.text('Utility'), findsOneWidget);
    final search = tester.widget<TextField>(
      find.byKey(const ValueKey('category-search')),
    );
    expect(
        search.decoration?.fillColor,
        AppFinanceSurfaceTheme.field(
            tester.element(find.byKey(const Key('category-search')))));

    await tester.tap(find.text('Utility'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('save-transaction')), findsOneWidget);
    expect(find.byKey(const Key('category-search')), findsNothing);
    expect(find.text('Utility'), findsOneWidget);
  });
}
