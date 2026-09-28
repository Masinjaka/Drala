import 'package:budgets/core/ui/app_responsive_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses the same design scale across device widths',
      (tester) async {
    for (final size in const [Size(360, 800), Size(402, 874), Size(412, 915)]) {
      double? scaledFontSize;
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: const TextScaler.linear(0.8),
          ),
          child: AppResponsiveScope(
            child: Builder(
              builder: (context) {
                scaledFontSize = MediaQuery.textScalerOf(context).scale(10);
                return const Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text('Responsive text'),
                );
              },
            ),
          ),
        ),
      );

      expect(scaledFontSize, closeTo(10.31, 0.02));
    }
  });

  testWidgets('preserves larger accessibility text scaling', (tester) async {
    double? scaledFontSize;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(1200, 900),
          textScaler: TextScaler.linear(1.2),
        ),
        child: AppResponsiveScope(
          child: Builder(
            builder: (context) {
              scaledFontSize = MediaQuery.textScalerOf(context).scale(10);
              return const Directionality(
                textDirection: TextDirection.ltr,
                child: Text('Responsive text'),
              );
            },
          ),
        ),
      ),
    );

    expect(scaledFontSize, 12);
  });
}
