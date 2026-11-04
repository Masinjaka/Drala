part of 'add_transaction_dialog.dart';

extension _AddTransactionDialogStateRemoveCard on _AddTransactionDialogState {
  void _removeCard(int index) {
    if (index >= _subcategoryAmounts.length || _removingIndices.contains(index))
      return;
    final target = index > 0 ? index - 1 : 0;
    _update(() => _removingIndices.add(index));
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      final removed = _subcategoryAmounts[index];
      removed['subcategoryController']?.dispose();
      removed['amountController']?.dispose();
      _update(() {
        _removingIndices.clear();
        _subcategoryAmounts.removeAt(index);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients && _subcategoryAmounts.isNotEmpty) {
          _pageController.animateToPage(
              target.clamp(0, _subcategoryAmounts.length - 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic);
        }
      });
    });
  }
}
