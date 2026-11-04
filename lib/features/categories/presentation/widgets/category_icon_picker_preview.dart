import 'package:budgets/core/theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_picker.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'Category icons', size: Size(390, 700))
Widget categoryIconPickerPreview() => MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: CategoryIconPicker(selected: 'food')),
    );
