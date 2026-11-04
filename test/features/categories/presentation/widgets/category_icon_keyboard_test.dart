import 'package:budgets/features/categories/presentation/widgets/category_icon_picker.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('icon picker stays above keyboard on a small phone',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => CategoryIconPicker.show(context),
            child: const Text('Open'),
          ),
        )));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    final picker = tester.getRect(find.byKey(const Key('category-icon-grid')));
    expect(picker.bottom, lessThanOrEqualTo(340));
    expect(picker.top, greaterThanOrEqualTo(0));
    expect(tester.takeException(), isNull);
  });
}
