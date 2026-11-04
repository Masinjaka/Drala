part of 'add_category_page.dart';

extension _AddCategoryLayout on _AddCategoryPageState {
  Widget _buildContent(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          if (widget.category != null)
            AppDeleteButton(
                tooltip: 'Supprimer',
                busy: _isDeleting,
                onPressed: _isDeleting
                    ? null
                    : () async {
                        _update(() => _isDeleting = true);
                        await _categoryModule.deleteCategory(
                            ref, widget.category!, context);
                        if (mounted) _update(() => _isDeleting = false);
                      }),
          if (!_isEditing) AppCloseButton(onPressed: () => context.pop()),
        ],
        backgroundColor: Colors.transparent,
        flexibleSpace: const GlassFlexibleSpace(),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isSavingsCategoryWithGoals
          ? _buildSavingsCategoryInfo(context)
          : _form(context),
      bottomNavigationBar: _isSavingsCategoryWithGoals
          ? null
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(32, 0, 32, 16),
                child: Row(
                  children: [
                    if (_isEditing) ...[
                      Expanded(
                          child: CustomButton(
                              text: 'Annuler', onPressed: () => context.pop())),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: CustomButton(
                        backgroundColor: Theme.of(context).primaryColor,
                        text: _isEditing ? 'Modifier' : 'Ajouter',
                        onPressed: () {
                          _update(() => _isLoading = true);
                          if (_isEditing) {
                            _categoryModule
                                .editCategory(
                                  ref,
                                  id: widget.category!.id!,
                                  name: _categoryNameController.text.trim(),
                                  emoji: _selectedEmoji,
                                  color: _selectedColor == null
                                      ? Colors.teal.value.toRadixString(16)
                                      : _selectedColor!.value.toRadixString(16),
                                  // transactionType: widget.category?.transactionType ?? transactionType,
                                  context: context,
                                  formKey: _formKey,
                                )
                                .whenComplete(
                                    () => _update(() => _isLoading = false));
                          } else {
                            _categoryModule
                                .addCategory(
                                  ref,
                                  name: _categoryNameController.text.trim(),
                                  emoji: _selectedEmoji,
                                  color: _selectedColor == null
                                      ? Colors.teal.value.toRadixString(16)
                                      : _selectedColor!.value.toRadixString(16),
                                  transactionType: transactionType,
                                  context: context,
                                  formKey: _formKey,
                                )
                                .whenComplete(
                                    () => _update(() => _isLoading = false));
                          }
                        },
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  GestureDetector _form(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 96), // Top padding for glass effect
                _nameCard(context),
                SizedBox(height: 24),
                _emojiCard(context),
                SizedBox(height: 24),
                _colorCard(context),
                SizedBox(height: 24),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ), // Padding
    ); // GestureDetector
  }
}
