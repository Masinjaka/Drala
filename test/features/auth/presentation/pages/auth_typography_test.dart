import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_responsive_scope.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login typography uses stable app tokens across phone sizes',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final size in [const Size(390, 844), const Size(412, 892)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(_app());
      await tester.pump();

      expect(tester.widget<Text>(find.text('Login').first).style?.fontSize,
          AppTypography.display);
      expect(tester.widget<Text>(find.text('Login').first).style?.fontWeight,
          FontWeight.w700);
      expect(tester.widget<Text>(find.text('Email')).style?.fontSize,
          AppTypography.supporting);
      for (final field in tester.widgetList<EditableText>(
        find.byType(EditableText),
      )) {
        expect(field.style.fontSize, AppTypography.supporting);
      }

      await tester.pumpWidget(const SizedBox.shrink());
    }
  });
}

Widget _app() => ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        builder: (_, child) => AppResponsiveScope(child: child!),
        home: const LoginPage(),
      ),
    );
