part of 'custom_subcategory_dropdown.dart';

extension _CustomSubcategoryField on _CustomSubcategoryDropdownState {
  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title,
        SizedBox(height: 8),
        FormField<Subcategory>(
          validator: (value) {
            if (widget.validator != null) {
              for (String type in widget.validator!.keys) {
                final error =
                    validate(type, widget.validator![type], _selectedItem);
                if (error != null) return error;
              }
            }
            return null;
          },
          builder: (FormFieldState<Subcategory> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input field
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceDim,
                    borderRadius: _isDropdownOpen
                        ? BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )
                        : BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          enabled: widget.enabled,
                          decoration: InputDecoration(
                            hintText: widget.hint ??
                                'Sélectionnez ou tapez une sous-catégorie',
                            hintStyle: AppTextStyle(AppTextRole.input,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withOpacity(0.6)),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          style: AppTextStyle(AppTextRole.input,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color),
                          onTap: () {
                            if (!_isDropdownOpen) {
                              widget.onTap?.call();
                              _openDropdown();
                            }
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleDropdown,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            _isDropdownOpen
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: AppIconForeground.resolve(
                              context,
                              Theme.of(context).textTheme.bodyLarge?.color ??
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Dropdown content - directly in widget tree
                if (_isDropdownOpen)
                  SizeTransition(
                    sizeFactor: _dropdownAnimation,
                    axisAlignment: -1.0,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 320,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: _buildDropdownContent(),
                      ),
                    ),
                  ),

                if (state.hasError)
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      state.errorText!,
                      style: AppTextStyle(AppTextRole.body,
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
