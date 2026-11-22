import 'package:budgets/features/home/presentation/widgets/settled_bottom_inset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const duration = Duration(milliseconds: 240);
  var builds = 0;
  double? seenInset;

  // One child instance, like the app's tab stack, so only inherited
  // padding changes can rebuild it.
  final page = Builder(builder: (context) {
    builds++;
    seenInset = MediaQuery.paddingOf(context).bottom;
    return const SizedBox();
  });

  Widget host({required int tab, required double inset}) => MediaQuery(
        data: MediaQueryData(padding: EdgeInsets.only(bottom: inset)),
        child: SettledBottomInset(
          trigger: tab,
          duration: duration,
          child: page,
        ),
      );

  setUp(() {
    builds = 0;
    seenInset = null;
  });

  testWidgets('holds the inset while the bar animates, then settles once',
      (tester) async {
    await tester.pumpWidget(host(tab: 0, inset: 80));
    await tester.pumpWidget(host(tab: 1, inset: 80));
    final buildsAtSwitch = builds;

    for (final inset in [100.0, 120.0, 140.0, 160.0]) {
      await tester.pumpWidget(host(tab: 1, inset: inset));
      await tester.pump(const Duration(milliseconds: 40));
    }
    expect(seenInset, 80, reason: 'page keeps its padding mid-animation');
    expect(builds, buildsAtSwitch, reason: 'no page rebuild per frame');

    await tester.pump(const Duration(milliseconds: 200));
    expect(seenInset, 160);
    expect(builds, buildsAtSwitch + 1);
  });

  testWidgets('passes changes straight through when the tab is unchanged',
      (tester) async {
    await tester.pumpWidget(host(tab: 0, inset: 80));
    await tester.pumpWidget(host(tab: 0, inset: 100));
    expect(seenInset, 100);
  });

  testWidgets('keeps the page state when settling', (tester) async {
    final key = GlobalKey();
    Widget app(int tab, double inset) => MediaQuery(
          data: MediaQueryData(padding: EdgeInsets.only(bottom: inset)),
          child: SettledBottomInset(
              trigger: tab,
              duration: duration,
              child: SizedBox(key: key)),
        );
    await tester.pumpWidget(app(0, 80));
    final element = key.currentContext;
    await tester.pumpWidget(app(1, 160));
    await tester.pump(const Duration(milliseconds: 400));
    expect(key.currentContext, same(element));
  });
}
