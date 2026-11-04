import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/presentation/widgets/category_grid_card.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_card.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_envelope_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const envelope = Envelope(
      id: 'envelope',
      name: 'Food',
      categoryId: 'food',
      categoryName: 'Food',
      emoji: '',
      iconKey: 'food',
      color: 'FF8040C0',
      amount: 100,
      spent: 20,
      currencyCode: 'MGA');
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'both envelope icons match category grid size in ${theme.brightness}',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          theme: theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
              body: SizedBox(
                  height: 170,
                  child: Row(children: [
                    Expanded(
                        child: CategoryGridCard(
                            category: Category(
                                id: 'food',
                                name: 'Food',
                                iconKey: 'food',
                                color: envelope.color,
                                transactionType: TransactionType.expense),
                            type: TransactionType.expense)),
                    Expanded(
                        child: HomeOverviewEnvelopeCard(
                            envelope: envelope, onPressed: () {})),
                    Expanded(
                        child:
                            EnvelopeCard(envelope: envelope, onDelete: () {})),
                  ])))));
      await tester.pumpAndSettle();
      final categoryIcons = find.byType(CategoryIcon);
      expect(categoryIcons, findsNWidgets(3));
      for (final element in categoryIcons.evaluate()) {
        final icon = element.widget as CategoryIcon;
        expect(icon.size, AppCategoryIconTheme.size);
        expect(icon.colorHex, envelope.color);
        final rendered = tester.widget<Icon>(find.descendant(
            of: find.byWidget(icon), matching: find.byType(Icon)));
        expect(rendered.size, 24);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
