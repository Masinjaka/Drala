import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/chat_input_bar.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'Activities navigation morph', size: Size(412, 500))
Widget homeBottomNavigationPreview() => MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeBottomNavigationPreview(),
    );

class HomeBottomNavigationPreview extends StatefulWidget {
  const HomeBottomNavigationPreview({super.key});
  @override
  State<HomeBottomNavigationPreview> createState() =>
      _HomeBottomNavigationPreviewState();
}

class _HomeBottomNavigationPreviewState
    extends State<HomeBottomNavigationPreview> {
  int _index = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
          bottomNavigationBar: HomeBottomNavigationBar(
        selectedIndex: _index,
        onSelected: (index) => setState(() => _index = index),
        composer: ChatInputBar(
            embedded: true,
            isSubmitting: false,
            onSubmit: (_) async => true,
            onManualEntryRequested: () async {}),
      ));
}
