part of 'custom_dropdown.dart';

extension _CustomDropdownField on _CustomDropdownState {
  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title,
        SizedBox(height: 8),
        FormField<Category>(
          validator: (Category? value) {
            return validate(
              widget.validator?['type'] ?? '',
              widget.validator?['error'] ?? '',
              _selectedItem,
            );
          },
          builder: (FormFieldState<Category> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  key: _dropdownKey,
                  onTap: _toggleDropdown,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: _isDropdownOpen
                          ? BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            )
                          : BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        if (_selectedItem != null && widget.showEmojis)
                          CategoryIcon(
                              iconKey: _selectedItem!.iconKey,
                              emoji: _selectedItem!.emoji,
                              colorHex: _selectedItem!.color,
                              size: 18,
                              backgroundColor: Theme.of(context).cardColor),
                        if (_selectedItem != null && widget.showEmojis)
                          SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedItem?.name ??
                                widget.hint ??
                                'Sélectionnez une option',
                            style: AppTextStyle(AppTextRole.input,
                                color: _selectedItem != null
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color
                                        ?.withAlpha(100)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          _isDropdownOpen
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: AppIconForeground.resolve(
                            context,
                            Theme.of(context).textTheme.bodyLarge?.color ??
                                Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
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
