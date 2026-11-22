import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/ai_entry/domain/models/ai_entry_result.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class AiEntryResultFeedback {
  const AiEntryResultFeedback._();

  static void show(BuildContext context, AiEntryResult result) {
    final l10n = context.l10n;
    final count = result.entries.length;
    final quota = result.unlimited
        ? l10n.unlimitedAiRequests
        : l10n.aiRequestsRemaining(result.remaining ?? 0);
    showAppToast(
      context,
      // With no entries, the AI's reply is already in the user's language.
      count == 0 ? result.message : '${l10n.aiEntriesAdded(count)} $quota',
      type: count == 0 ? AppToastType.info : AppToastType.success,
    );
    if (result.notice != null) showInfoToast(context, l10n.aiPaidTierNotice);
  }
}
