import 'dart:async';

import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/home/domain/models/receipt_input_result.dart';
import 'package:budgets/features/home/presentation/services/receipt_input_service.dart';
import 'package:budgets/features/home/presentation/widgets/chat_example_suggestions.dart';
import 'package:budgets/features/home/presentation/widgets/chat_input_suggestions.dart';
import 'package:budgets/features/home/presentation/widgets/chat_send_button.dart';
import 'package:budgets/features/home/presentation/widgets/chat_suggestions_reveal.dart';
import 'package:budgets/features/home/presentation/widgets/chat_text_input.dart';
import 'package:budgets/features/home/presentation/widgets/receipt_input_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:budgets/l10n/app_localizations_context.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    required this.onSubmit,
    required this.isSubmitting,
    required this.onManualEntryRequested,
    this.onReceiptSubmit,
    this.isQuotaExhausted = false,
    this.currencyCode = 'MGA',
    this.receiptInputService = const ReceiptInputService(),
    super.key,
  });
  final Future<bool> Function(String message) onSubmit;
  final bool isSubmitting;
  final Future<void> Function() onManualEntryRequested;
  final Future<bool> Function(ReceiptInputResult input)? onReceiptSubmit;
  final bool isQuotaExhausted;
  final String currencyCode;
  final ReceiptInputService receiptInputService;
  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}
class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController(), _focusNode = FocusNode();
  bool _isProcessingReceipt = false;
  int _hintIndex = 0;
  Timer? _hintTimer;
  @override
  void initState() {
    super.initState();
    _controller.addListener(_refreshComposer);
    _focusNode.addListener(_refreshComposer);
    _hintTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted && _controller.text.isEmpty) {
        setState(() => _hintIndex = (_hintIndex + 1) % 3);
      }
    });
  }
  void _refreshComposer() => setState(() {});
  @override
  void dispose() {
    _hintTimer?.cancel();
    _controller.removeListener(_refreshComposer);
    _focusNode.removeListener(_refreshComposer);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _useSuggestion(String suggestion) {
    _controller.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.collapsed(offset: suggestion.length),
    );
    _focusNode.requestFocus();
  }

  Future<void> _submit() async {
    if (widget.isQuotaExhausted) {
      await widget.onManualEntryRequested();
      return;
    }
    final message = _controller.text.trim();
    if (message.isEmpty || widget.isSubmitting) return;
    FocusScope.of(context).unfocus();
    if (await widget.onSubmit(message) && mounted) {
      _controller.clear();
    }
  }

  Future<void> _showReceiptOptions() async {
    final action = await ReceiptInputBottomSheet.show(context);
    if (action == null || !mounted) return;
    if (action == ReceiptInputAction.manualEntry) {
      await widget.onManualEntryRequested();
      return;
    }
    try {
      setState(() => _isProcessingReceipt = true);
      final result = switch (action) {
        ReceiptInputAction.manualEntry => null,
        ReceiptInputAction.importFile =>
          await widget.receiptInputService.importFile(),
        ReceiptInputAction.scanReceipt =>
          await widget.receiptInputService.scanReceipt(),
      };
      if (result == null || result.isEmpty || !mounted) return;
      final submit = widget.onReceiptSubmit;
      if (submit == null) {
        _showResult(result);
      } else {
        await submit(result);
      }
    } on StateError catch (error) {
      if (mounted) showAppToast(context, error.message);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _isProcessingReceipt = false);
    }
  }

  void _showResult(ReceiptInputResult result) {
    final label = result.source == ReceiptInputSource.importedFile
        ? 'File imported'
        : 'Receipt scanned';
    showInfoToast(context, '$label and ready for AI extraction.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hints = [
      context.l10n.chatHint,
      context.l10n.chatIncomeHint,
      context.l10n.chatTransferHint,
    ];
    final isBusy = widget.isSubmitting || _isProcessingReceipt;
    final showSuggestions =
        _focusNode.hasFocus && _controller.text.trim().isEmpty && !isBusy;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChatSuggestionsReveal(
          visible: showSuggestions,
          child: ChatInputSuggestions(
            suggestions:
                ChatExampleSuggestions.build(context, widget.currencyCode),
            onSelected: _useSuggestion,
          ),
        ),
        Container(
          key: const Key('chat-input-container'),
          constraints: const BoxConstraints(minHeight: 56, maxHeight: 120),
          margin: const EdgeInsets.symmetric(horizontal: 29),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: IconButton(
                  onPressed: isBusy ? null : _showReceiptOptions,
                  icon: const Icon(Icons.add_rounded, size: 29),
                  padding: EdgeInsets.zero,
                  tooltip: context.l10n.addReceipt,
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 56),
                  child: ChatTextInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: !isBusy,
                    hint: hints[_hintIndex],
                    cursorColor: theme.colorScheme.inverseSurface,
                    hintColor: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              ChatSendButton(
                key: Key(
                  widget.isQuotaExhausted ? 'manual-entry-send' : 'ai-send',
                ),
                isBusy: isBusy,
                isManualEntry: widget.isQuotaExhausted,
                onPressed: isBusy
                    ? null
                    : widget.isQuotaExhausted
                        ? widget.onManualEntryRequested
                        : _submit,
                tooltip: widget.isQuotaExhausted
                    ? context.l10n.manualEntry
                    : context.l10n.send,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
