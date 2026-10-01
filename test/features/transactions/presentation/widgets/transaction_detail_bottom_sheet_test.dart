import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
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

  testWidgets('matches the inset geometry and does not grow on upward drag',
      (tester) async {
    await pumpSheet(tester);

    final rect = tester.getRect(
      find.byKey(const ValueKey('transaction-sheet-surface')),
    );
    expect(rect.left, closeTo(24, 0.1));
    expect(rect.width, closeTo(364, 0.1));
    expect(rect.bottom, closeTo(893, 0.1));
    expect(find.text('Edit transaction'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Bought food for my sweet family'), findsOneWidget);
    final fields =
        tester.widgetList<InputDecorator>(find.byType(InputDecorator));
    expect(fields.elementAt(1).decoration.fillColor,
        AppTheme.lightTheme.colorScheme.surfaceContainer);
    expect(fields.elementAt(2).decoration.fillColor,
        AppTheme.lightTheme.colorScheme.surfaceContainer);
    final categoryField = tester.widget<Material>(
      find.byKey(const ValueKey('transaction-category-field')),
    );
    expect(categoryField.color,
        AppTheme.lightTheme.colorScheme.surfaceContainer);
    final surface = tester.widget<Container>(
      find.byKey(const ValueKey('transaction-sheet-surface')),
    );
    final decoration = surface.decoration! as BoxDecoration;
    expect(decoration.color,
        AppTheme.lightTheme.colorScheme.surfaceContainerLowest);
    final lastFieldRect = tester.getRect(find.byType(InputDecorator).last);
    final deleteButtonRect = tester.getRect(
      find.byKey(const ValueKey('delete-transaction')),
    );
    expect(
        deleteButtonRect.top - lastFieldRect.bottom, greaterThanOrEqualTo(16));

    final gesture = await tester.startGesture(const Offset(206, 500));
    await gesture.moveBy(const Offset(0, -100));
    await tester.pump();
    final draggedRect = tester.getRect(
      find.byKey(const ValueKey('transaction-sheet-surface')),
    );
    expect(draggedRect.top, closeTo(rect.top, 0.1));
    expect(draggedRect.left, closeTo(rect.left, 0.1));
    await gesture.up();
  });

  testWidgets('category field animates to the picker in the same sheet',
      (tester) async {
    await pumpSheet(tester);

    await tester.tap(
      find.byKey(const ValueKey('transaction-category-field')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Categories'), findsOneWidget);
    expect(find.byKey(const ValueKey('category-search')), findsOneWidget);
    expect(find.text('🔦 Utility'), findsOneWidget);
    final search = tester.widget<TextField>(
      find.byKey(const ValueKey('category-search')),
    );
    expect(search.decoration?.fillColor,
        AppTheme.lightTheme.colorScheme.surfaceContainer);

    await tester.tap(find.text('🔦 Utility'));
    await tester.tap(find.byKey(const ValueKey('category-done')));
    await tester.pumpAndSettle();

    expect(find.text('Edit transaction'), findsOneWidget);
    expect(find.text('🔦 Utility'), findsOneWidget);
  });
}
