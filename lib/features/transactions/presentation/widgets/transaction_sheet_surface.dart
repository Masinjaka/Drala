import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_motion.dart';
import 'package:flutter/material.dart';

class TransactionSheetSurface extends StatelessWidget {
  const TransactionSheetSurface({
    super.key,
    required this.pageController,
    required this.pages,
  });

  final PageController pageController;
  final List<Widget> pages;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surfaceContainerLowest;
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final bottomSafeArea = MediaQuery.viewPaddingOf(context).bottom;
    final keyboardOffset = keyboardHeight > 0
        ? (keyboardHeight + 12 - bottomSafeArea).clamp(0.0, double.infinity)
        : 0.0;
    return SafeArea(
      top: false,
      maintainBottomViewPadding: keyboardHeight > 0,
      child: Transform.translate(
        offset: Offset(0, -keyboardOffset),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: transactionSheetInitialExtent,
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                key: const ValueKey('transaction-sheet-surface'),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 28,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: pages,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
