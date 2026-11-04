import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/features/receipts/domain/models/receipt_scan.dart';
import 'package:budgets/features/receipts/presentation/widgets/receipt_gallery_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses the neutral surface and danger color for delete',
      (tester) async {
    var deleted = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SizedBox(
            width: 220,
            height: 320,
            child: ReceiptGalleryCard(
              scan: ReceiptScan(
                id: 'receipt',
                storagePaths: const ['receipt.pdf'],
                mimeTypes: const ['application/pdf'],
                signedUrls: const ['https://example.test/receipt.pdf'],
                status: 'processed',
                createdAt: DateTime(2026, 7, 25),
              ),
              onTap: () {},
              onDelete: () => deleted = true,
              isDeleting: false,
            ),
          ),
        ),
      ),
    );

    final button = tester.widget<IconButton>(
      find.descendant(
          of: find.byKey(const Key('receipt-delete-button')),
          matching: find.byType(IconButton)),
    );
    expect(
      button.style?.backgroundColor?.resolve({}),
      AppFinanceSurfaceTheme.field(
          tester.element(find.byKey(const Key('receipt-delete-button')))),
    );
    expect(
      button.style?.foregroundColor?.resolve({}),
      AppFinanceSurfaceTheme.destructive(
          tester.element(find.byKey(const Key('receipt-delete-button')))),
    );

    await tester.tap(find.byKey(const Key('receipt-delete-button')));
    expect(deleted, isTrue);
  });
}
