import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:budgets/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('password and email fields have the same height', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LoginPage(),
        ),
      ),
    );
    await tester.pump();

    final fields = find.byType(TextFormField);
    final emailSize = tester.getSize(fields.at(0));
    final passwordSize = tester.getSize(fields.at(1));

    expect(emailSize.height, AppControlMetrics.height);
    expect(passwordSize.height, emailSize.height);
  });
}
