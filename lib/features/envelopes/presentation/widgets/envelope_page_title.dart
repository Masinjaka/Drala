import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class EnvelopePageTitle extends StatelessWidget {
  const EnvelopePageTitle({this.onSelect, super.key});
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final title = Text(context.l10n.envelope,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppEnvelopeTheme.title(context));
    if (onSelect == null) return title;
    return PopupMenuButton<void>(
        key: const Key('envelope-page-menu'),
        tooltip: context.l10n.selectItems,
        itemBuilder: (context) => [
              PopupMenuItem<void>(
                  key: const Key('select-items'),
                  onTap: onSelect,
                  child: Text(context.l10n.selectItems,
                      style: AppEnvelopeTheme.name(context)))
            ],
        child:
            Align(alignment: AlignmentDirectional.centerStart, child: title));
  }
}
