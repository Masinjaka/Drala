import 'package:budgets/features/home/presentation/widgets/home_operations_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final height in [0.0, 10.6, 22.0]) {
    testWidgets('transaction heading fits in a $height pixel viewport',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: height,
            child: HomeOperationsList(
              entries: const [],
              isLoading: false,
              isAdding: false,
              onEntryTap: (_) {},
            ),
          ),
        )),
      ));
      expect(tester.takeException(), isNull);
      expect(
          tester
              .getSize(find.byKey(const Key('transaction-scroll-view')))
              .height,
          height);
    });
  }
}
