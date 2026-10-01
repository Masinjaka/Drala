import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/home/domain/models/receipt_input_result.dart';
import 'package:budgets/features/home/presentation/services/receipt_input_service.dart';
import 'package:budgets/features/home/presentation/widgets/chat_example_suggestions.dart';
import 'package:budgets/features/home/presentation/widgets/chat_input_composer_layout.dart';
import 'package:budgets/features/home/presentation/widgets/chat_send_button.dart';
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
  final _textInputKey = GlobalKey();
  bool _isProcessingReceipt = false;
  @override
  void initState() {
    super.initState();
    _controller.addListener(_refreshComposer);
    _focusNode.addListener(_refreshComposer);
  }

  void _refreshComposer() => setState(() {});
  @override
  void dispose() {
    _controller.removeListener(_refreshComposer);
    _focusNode.removeListener(_refreshComposer);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
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
    final suggestions =
        ChatExampleSuggestions.build(context, widget.currencyCode);
    final isBusy = widget.isSubmitting || _isProcessingReceipt;
    final isFocused = _focusNode.hasFocus;
    final animationDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 220);
    final textInput = ChatTextInput(
      key: _textInputKey,
      controller: _controller,
      focusNode: _focusNode,
      enabled: !isBusy,
      hints: suggestions,
      cursorColor: theme.colorScheme.inverseSurface,
      hintColor: theme.colorScheme.onSurfaceVariant,
    );
    final addButton = SizedBox(
      width: 48,
      height: 40,
      child: IconButton(
        onPressed: isBusy ? null : _showReceiptOptions,
        icon: const Icon(Icons.add_rounded, size: 22),
        padding: EdgeInsets.zero,
        tooltip: context.l10n.addReceipt,
      ),
    );
    final sendButton = ChatSendButton(
      key: Key(widget.isQuotaExhausted ? 'manual-entry-send' : 'ai-send'),
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
      bottomPadding: isFocused ? 4 : 0,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFieldTapRegion(
          consumeOutsideTaps: isFocused,
          child: AnimatedSize(
            duration: animationDuration,
            curve: Curves.easeInOutCubic,
            alignment: Alignment.bottomCenter,
            child: Container(
              key: const Key('chat-input-container'),
              constraints: BoxConstraints(
                minHeight: isFocused ? 85 : 48,
                maxHeight: isFocused ? 157 : 48,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 29),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light
                    ? const Color(0xFFF4F4F4)
                    : theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ChatInputComposerLayout(
                isFocused: isFocused,
                textInput: textInput,
                addButton: addButton,
                sendButton: sendButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
