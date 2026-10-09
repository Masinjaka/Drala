import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MalagasyMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const MalagasyMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'mg';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return GlobalMaterialLocalizations.delegate.load(const Locale('fr'));
  }

  @override
  bool shouldReload(MalagasyMaterialLocalizationsDelegate old) => false;
}

class MalagasyCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const MalagasyCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'mg';

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return GlobalCupertinoLocalizations.delegate.load(const Locale('fr'));
  }

  @override
  bool shouldReload(MalagasyCupertinoLocalizationsDelegate old) => false;
}
