import 'package:budgets/core/ui/app_grid_background.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_completion.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_header.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_submit_bar.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SetupCompletePage extends ConsumerStatefulWidget {
  const SetupCompletePage({super.key});
  @override
  ConsumerState<SetupCompletePage> createState() => _SetupCompletePageState();
}

class _SetupCompletePageState extends ConsumerState<SetupCompletePage> {
  bool _busy = false;

  Future<void> _done() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(guestSessionProvider)?.markCompletionSeen();
      if (mounted) context.go('/home');
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          body: AppGridBackground(
              child: Center(
                  child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(children: [
              const SetupHeader(
                  currentStep: 6, onBack: null, showDisabledBack: true),
              Expanded(
                  child: SingleChildScrollView(
                      child: SetupCompletion(
                title: context.l10n.setupCompleteTitle,
                subtitle: context.l10n.setupCompleteBody,
                entranceDelay: const Duration(milliseconds: 100),
              ))),
            ]),
          ))),
          bottomNavigationBar: SetupSubmitBar(
            text: context.l10n.setupDone,
            onPressed: _busy ? null : _done,
            isLoading: _busy,
            primary: true,
          ),
        ),
      );
}
