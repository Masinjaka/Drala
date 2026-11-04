part of 'add_transaction.dart';

extension _TransactionCreationPageStateBuildBody
    on _TransactionCreationPageState {
  Widget _buildBody() {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(left: 32, right: 32, top: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  if (_selectedCategory?.name !=
                      SystemCategories.savingsCategoryName) ...[
                    DetailedTransactionSwitch(
                      value: _isMultipleAmounts,
                      onChanged: (value) {
                        _update(() {
                          _isMultipleAmounts = value;
                          if (!value) {
                            _module.clearAllSubcategoryAmounts(
                                subcategoryAmounts: _subcategoryAmounts,
                                listKey: _listKey,
                                buildRemovedItem: (item, _, anim) =>
                                    _buildRemovedItem(item, anim),
                                onStateChanged: () => _update(() {}));
                          }
                        });
                      },
                    ),
                    SizedBox(height: 40),
                  ],
                  ValidatedSelection(
                      value: _selectedCategory?.id,
                      child: CustomDropdown(
                        title: Text('Catégorie',
                            textAlign: TextAlign.left,
                            style: AppTextStyle(AppTextRole.body)),
                        hint: 'Choisissez une catégorie',
                        items: _categories,
                        selectedValue: _selectedCategory,
                        enabled: _selectedCategory?.name !=
                            SystemCategories.savingsCategoryName,
                        onChanged: (Category? category) async {
                          _update(() {
                            _selectedCategory = category;
                            _subcategories = [];
                          });
                          if (category?.id != null) {
                            try {
                              final subs = await _module.fetchSubcategories(
                                  ref, category!.id!);
                              _update(() => _subcategories = subs);
                            } catch (_) {
                              _update(() => _subcategories = []);
                            }
                          }
                        },
                        validator: const <String, String>{"type": "required"},
                        showEmojis: true,
                      )),
                  SizedBox(height: 16),
                  if (!_isMultipleAmounts)
                    CustomTextField(
                      title: const SizedBox.shrink(),
                      hint: '0.00',
                      controller: _montantController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      fontSize: AppTypography.display,
                      height: 128,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(20),
                      validator: const <String, String>{"type": "required"},
                    )
                  else
                    ValidatedSelection(
                        value: _subcategoryAmounts.length,
                        validator: () => _subcategoryAmounts.isNotEmpty &&
                                _module.validateSubcategoryAmounts(
                                    _subcategoryAmounts)
                            ? null
                            : FieldValidators.required(context, null),
                        child: MultipleAmountsSection(
                          subcategoryAmounts: _subcategoryAmounts,
                          subcategories: _subcategories,
                          listKey: _listKey,
                          module: _module,
                          onStateChanged: () => _update(() {}),
                          buildRemovedItem: _buildRemovedItem,
                          onSubcategoryChanged: (sub, item) => _update(() {}),
                          onSubcategoryTapWithoutCategory: () {
                            if (_selectedCategory == null) {
                              _formKey.currentState?.validate();
                            }
                          },
                        )),
                  CustomTextField(
                    title: const SizedBox.shrink(),
                    hint: _selectedCategory?.name ==
                            SystemCategories.savingsCategoryName
                        ? _descriptionController.text
                        : 'Ajouter une description (optionnel)',
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    maxLines: null,
                    isReadOnly: _selectedCategory?.name ==
                        SystemCategories.savingsCategoryName,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  if (isEditMode) ...[
                    SizedBox(height: 16),
                    TransactionDatePickerField(
                      selectedDate: _selectedDate,
                      isReadOnly: _selectedCategory?.name ==
                          SystemCategories.savingsCategoryName,
                      onDateSelected: (date) =>
                          _update(() => _selectedDate = date),
                    ),
                  ],
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
