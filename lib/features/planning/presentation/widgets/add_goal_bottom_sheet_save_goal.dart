part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateSaveGoal on _AddGoalBottomSheetState {
  Future<void> _saveGoal() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      showAppToast(
        context,
        'Utilisateur non authentifié',
        type: AppToastType.error,
      );
      return;
    }

    _update(() => _isLoading = true);

    try {
      final currencyState = await ref.read(currencyControllerProvider.future);
      final rate = currencyState.rateFor(currencyState.code);
      final displayAmount = parseAmountInput(_amountController.text);
      final goalAmountMga = convertToMga(displayAmount, rate).round();

      final goal = Goal(
        id: widget.goal?.id,
        userId: userId,
        name: _nameController.text.trim(),
        category: Category(id: _selectedCategoryId),
        goalAmount: goalAmountMga.toString(),
        currentAmount: widget.goal?.currentAmount ?? '0',
        dateAim: _targetDate,
        imagePath: _imagePath,
      );

      if (_isEditing) {
        await ref.read(goalsProvider.notifier).updateSomeGoal(
              goal,
              oldImagePath: widget.goal?.imagePath,
            );
      } else {
        await ref.read(goalsProvider.notifier).addSomeGoal(goal);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on SocketException {
      if (mounted) {
        showInfoToast(
          context,
          'Erreur réseau: Vérifiez votre connexion internet',
        );
      }
    } on StorageException catch (e) {
      if (mounted) {
        showErrorToast(context, e);
      }
    } on FileSystemException {
      if (mounted) {
        showAppToast(
          context,
          "Impossible d'accéder au fichier image",
          type: AppToastType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(context, e);
      }
    } finally {
      if (mounted) {
        _update(() => _isLoading = false);
      }
    }
  }
}
