part of 'envelope_page.dart';

extension _EnvelopePageSelection on EnvelopePageState {
  Widget? get _selectionBar => !_viewModel.supportsBulkDeletion || !_selecting
      ? null
      : BulkSelectionBar(
          selecting: _selecting,
          count: _selected.length,
          busy: _viewModel.isSaving,
          onSelect: () => _update(() => _selecting = true),
          onCancel: _cancelSelection,
          onDelete: _deleteSelected);

  void _cancelSelection() {
    if (!_selecting) return;
    _update(() {
      _selecting = false;
      _selected.clear();
    });
  }

  void _toggleSelection(String id) {
    if (_viewModel.isSaving) return;
    _update(() {
      if (!_selected.add(id)) _selected.remove(id);
    });
  }

  Future<void> _deleteSelected() async {
    if (_viewModel.isSaving || _selected.isEmpty) return;
    final ids = _selected.toList(growable: false);
    final confirmed = await showDeleteConfirmationDialog(
        context: context,
        title: context.l10n.deleteSelectedItems,
        message: context.l10n.deleteSelectedEnvelopesDescription(ids.length));
    if (!mounted || !confirmed) return;
    try {
      await _viewModel.deleteMany(ids);
      if (mounted) _cancelSelection();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }
}
