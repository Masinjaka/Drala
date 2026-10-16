import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/onboarding/domain/models/wallet_preset_names.dart';
import 'package:flutter/widgets.dart';

String localizedWalletName(BuildContext context, WalletSummary wallet) {
  final language = Localizations.localeOf(context).languageCode;
  for (final entry in walletPresetNames.entries) {
    final slug = entry.key;
    final matchesIcon = wallet.iconKey == slug || wallet.iconKey == 'wallet';
    if (!matchesIcon) continue;
    final knownNames = entry.value.values.toSet();
    if (slug == 'bank') knownNames.add('Bank');
    if (knownNames.any(
      (name) => name.toLowerCase() == wallet.name.toLowerCase(),
    )) {
      return entry.value[language] ?? entry.value['en']!;
    }
  }
  return wallet.name;
}
