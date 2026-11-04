part of 'add_transaction_dialog.dart';

extension _AddTransactionDialogStateBuild on _AddTransactionDialogState {
  Widget _buildFormContent(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20 + 16, vertical: 40),
        child: _isInitializing
            ? SizedBox(
                height: 240,
                child: Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor)))
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DialogHeader(
                            type: widget.transactionType,
                            onClose: () => Navigator.of(context).pop(false)),
                        SizedBox(height: 16),
                        PerSubcategorySwitch(
                            value: _isPerSubcategory,
                            onChanged: _togglePerSubcategory),
                        SizedBox(height: 8),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, anim) => ScaleTransition(
                              scale: anim,
                              child: SizeTransition(
                                  sizeFactor: anim,
                                  axisAlignment: -1.0,
                                  child: child)),
                          child: _isPerSubcategory
                              ? const SizedBox.shrink(key: ValueKey('empty'))
                              : ValidatedInput(
                                  controller: _montantController,
                                  validator: (value) =>
                                      FieldValidators.positiveAmount(
                                          context, value),
                                  child: AnimatedAmountField(
                                      key: const ValueKey('amt'),
                                      controller: _montantController,
                                      hint: '0.00',
                                      fontSize: AppTypography.display,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceDim,
                                      height: 120,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(12))),
                        ),
                        SizedBox(height: 16),
                        ValidatedSelection(
                            value: _selectedCategory?.id,
                            child: CategoryPillsSection(
                              categories: _categories,
                              selectedCategory: _selectedCategory,
                              isPerSubcategory: _isPerSubcategory,
                              onCategoryTap: _onCategoryTap,
                              onAddCategoryTap: (ctx) async {
                                final newCat = await AddCategoryDialog.show(ctx,
                                    transactionType: widget.transactionType);
                                if (newCat != null) {
                                  await _loadCategories();
                                  final created = _categories.firstWhere(
                                      (c) => c.name == newCat.name,
                                      orElse: () => newCat);
                                  _update(() => _selectedCategory = created);
                                }
                              },
                            )),
                        SizedBox(height: 16),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeOutBack,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, anim) => ScaleTransition(
                              scale: anim,
                              alignment: Alignment.topCenter,
                              child: SizeTransition(
                                  sizeFactor: anim,
                                  axisAlignment: -1.0,
                                  child: FadeTransition(
                                      opacity: anim, child: child))),
                          child: _isPerSubcategory
                              ? Column(
                                  key: const ValueKey('subs'),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                      ValidatedSelection(
                                          value: _subcategoryAmounts.length,
                                          validator: () => !_isPerSubcategory ||
                                                  (_subcategoryAmounts
                                                          .isNotEmpty &&
                                                      _module.validateSubcategoryAmounts(
                                                          _subcategoryAmounts))
                                              ? null
                                              : FieldValidators.required(
                                                  context, null),
                                          child: SubcategoryPagerSection(
                                              subcategoryAmounts:
                                                  _subcategoryAmounts,
                                              pageController: _pageController,
                                              removingIndices: _removingIndices,
                                              newlyAddedIndex: _newlyAddedIndex,
                                              onRemove: _removeCard,
                                              onAdd: _addCard,
                                              onSubcategoryTap:
                                                  _onSubcategoryTap)),
                                      SizedBox(height: 16),
                                    ])
                              : const SizedBox.shrink(key: ValueKey('noSubs')),
                        ),
                        CustomTextField(
                            title: Text('Description (optionnel)',
                                style: AppTextStyle(AppTextRole.body)),
                            hint: 'Ajouter une description',
                            controller: _descriptionController,
                            keyboardType: TextInputType.text,
                            maxLines: 2,
                            borderRadius: BorderRadius.circular(12)),
                        SizedBox(height: 24),
                        CustomButton(
                            text: 'Confirmer',
                            backgroundColor: Theme.of(context).primaryColor,
                            onPressed: _submit,
                            isLoading: _isLoading),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
