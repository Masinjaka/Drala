part of 'custom_subcategory_dropdown.dart';

extension _CustomSubcategoryOptions on _CustomSubcategoryDropdownState {
  Widget _buildDropdownContent() {
    final searchText = _searchController.text.trim();
    final hasFilteredItems = _filteredItems.isNotEmpty;
    final showCustomOption = searchText.isNotEmpty &&
        !_filteredItems.any(
            (item) => item.name?.toLowerCase() == searchText.toLowerCase());

    if (!hasFilteredItems && !showCustomOption) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Text(
          searchText.isEmpty
              ? 'Aucune sous-catégorie disponible'
              : 'Aucune sous-catégorie trouvée',
          style: AppTextStyle(AppTextRole.input,
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.color
                  ?.withOpacity(0.6)),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Show filtered subcategories
          ...(_filteredItems.map((item) {
            final isSelected = _selectedItem?.id == item.id;
            return GestureDetector(
              onTap: () {
                _update(() {
                  _selectedItem = item;
                  _searchController.text = item.name ?? '';
                });
                widget.onChanged?.call(item);
                _closeDropdown();
                _focusNode.unfocus();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).highlightColor
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 16,
                      color: AppIconForeground.resolve(
                        context,
                        Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color
                                ?.withOpacity(0.7) ??
                            Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.name ?? '',
                        style: AppTextStyle(AppTextRole.input,
                            color: isSelected
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withOpacity(0.8)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),

          // Show custom option if search text doesn't match any existing item
          if (showCustomOption) ...[
            if (hasFilteredItems)
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: Theme.of(context).dividerColor,
              ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  onTap: () async {
                    // Haptic feedback
                    if (await Vibration.hasVibrator()) {
                      Vibration.vibrate(duration: 10);
                    }

                    final customSubcategory = Subcategory(name: searchText);
                    _update(() {
                      _selectedItem = customSubcategory;
                    });
                    widget.onChanged?.call(customSubcategory);
                    _closeDropdown();
                    _focusNode.unfocus();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 16,
                          color: AppIconForeground.resolve(
                            context,
                            Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withOpacity(0.9) ??
                                Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Créer "$searchText"',
                          style: AppTextStyle(AppTextRole.input,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color
                                  ?.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
