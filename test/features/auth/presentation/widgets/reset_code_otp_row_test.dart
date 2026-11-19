import 'package:budgets/core/theme.dart';
import 'package:budgets/features/auth/presentation/widgets/reset_code_otp_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final width in [320.0, 412.0]) {
    for (final dark in [false, true]) {
      testWidgets('six equal upright OTP slots at width=$width dark=$dark',
          (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controllers = List.generate(6, (_) => TextEditingController());
        final nodes = List.generate(6, (_) => FocusNode());
        addTearDown(() {
          for (final controller in controllers) {
            controller.dispose();
          }
          for (final node in nodes) {
            node.dispose();
          }
        });
        await tester.pumpWidget(MaterialApp(
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: Scaffold(
              body: Padding(
            padding: const EdgeInsets.all(24),
            child: ResetCodeOtpRow(controllers: controllers, focusNodes: nodes),
          )),
        ));
        final fields = find.byType(TextFormField);
        expect(fields, findsNWidgets(6));
        final size = tester.getSize(fields.first);
        expect(size.height, greaterThan(size.width));
        for (var i = 0; i < 6; i++) {
          expect(tester.getSize(fields.at(i)), size);
        }
        await tester.tap(fields.first);
        await tester.enterText(fields.first, '2');
        await tester.pump();
        expect(controllers.first.text, '2');
        expect(nodes[1].hasFocus, isTrue);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
