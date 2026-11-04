import 'dart:math' as math;
import 'dart:async';
import 'transaction_picker_scope.dart';
import 'transaction_sheet_motion.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:flutter/material.dart';

class ReferenceTransactionSurface extends StatefulWidget {
  const ReferenceTransactionSurface(
      {required this.controller,
      required this.pages,
      this.initialHeightFactor = .86,
      super.key});
  final PageController controller;
  final List<Widget> pages;
  final double initialHeightFactor;
  @override
  State<ReferenceTransactionSurface> createState() =>
      _ReferenceTransactionSurfaceState();
}

class _ReferenceTransactionSurfaceState
    extends State<ReferenceTransactionSurface> {
  Widget? _picker;
  Completer<String?>? _result;
  bool _closing = false;

  Future<String?> _open(Widget Function(ValueChanged<String?>) builder) async {
    if (_result != null) return null;
    final result = Completer<String?>();
    _result = result;
    setState(() => _picker = builder(_finish));
    if (widget.pages.length < 2) await WidgetsBinding.instance.endOfFrame;
    if (mounted) {
      await widget.controller.animateToPage(1,
          duration: const Duration(milliseconds: 420),
          curve: transactionSheetCurve);
    }
    return result.future;
  }

  Future<void> _finish(String? value) async {
    if (_closing || _result == null) return;
    _closing = true;
    FocusScope.of(context).unfocus();
    await widget.controller.animateToPage(0,
        duration: const Duration(milliseconds: 420),
        curve: transactionSheetCurve);
    if (!mounted) return;
    _result?.complete(value);
    _result = null;
    setState(() {
      _picker = null;
      _closing = false;
    });
  }

  @override
  void dispose() {
    _result?.complete(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
      canPop: _picker == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _picker != null) _finish(null);
      },
      child: TransactionPickerScope(
          open: _open,
          child: AnimatedBuilder(
              animation: widget.controller,
              builder: (context, _) => LayoutBuilder(builder: _surface))));

  Widget _surface(BuildContext context, BoxConstraints constraints) {
    final media = MediaQuery.of(context);
    final keyboard = media.viewInsets.bottom;
    final page = widget.controller.hasClients &&
            widget.controller.position.hasContentDimensions
        ? (widget.controller.page ?? 0).clamp(0.0, 1.0)
        : 0.0;
    final height = math
        .min(media.size.height * (widget.initialHeightFactor - .24 * page),
            constraints.maxHeight - keyboard - media.padding.top - 8)
        .clamp(160.0, double.infinity);
    return Padding(
        padding: EdgeInsets.only(bottom: keyboard),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: SizedBox(
                    height: height,
                    width: double.infinity,
                    child: Material(
                      key: const Key('transaction-sheet-surface'),
                      color: AppFinanceSurfaceTheme.background(context),
                      borderRadius: AppFinanceSurfaceTheme.sheetRadius,
                      clipBehavior: Clip.antiAlias,
                      child: FinanceSheetScope(
                          child: SafeArea(
                              top: false,
                              child: GestureDetector(
                                  onTap: () => FocusScope.of(context).unfocus(),
                                  child: PageView(
                                      controller: widget.controller,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        widget.pages.first,
                                        if (_picker != null)
                                          _picker!
                                        else
                                          ...widget.pages.skip(1)
                                      ])))),
                    )))));
  }
}
