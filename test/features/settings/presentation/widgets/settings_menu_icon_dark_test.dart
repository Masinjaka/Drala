import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dark menu icon is white without changing its background',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      home: const Scaffold(
        body: SettingsMenuIcon(asset: 'assets/settings/language.svg'),
      ),
    ));

    final context = tester.element(find.byType(SettingsMenuIcon));
    final pictures =
        tester.widgetList<SvgPicture>(find.byType(SvgPicture)).toList();
    expect(pictures, hasLength(2));
    expect(
      pictures.first.colorFilter,
      ColorFilter.mode(AppSettingsTheme.iconSurface(context), BlendMode.srcIn),
    );
    expect(
      pictures.last.colorFilter,
      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  });
}
