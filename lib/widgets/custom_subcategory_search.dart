part of 'custom_subcategory_dropdown.dart';

extension _CustomSubcategorySearch on _CustomSubcategoryDropdownState {
  void _onSearchChanged() {
    _filterItems(_searchController.text);
    if (!_isDropdownOpen && _focusNode.hasFocus) {
      _openDropdown();
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && !_isDropdownOpen) {
      // Call onTap callback before showing dropdown
      widget.onTap?.call();
      if (_searchController.text.isNotEmpty || widget.items.isNotEmpty) {
        _openDropdown();
      }
    } else if (!_focusNode.hasFocus && _isDropdownOpen) {
      // Allow some delay for item selection
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!_focusNode.hasFocus) {
          _closeDropdown();
          _handleCustomSubcategory();
        }
      });
    }
  }

  void _filterItems(String query) {
    _update(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          return item.name?.toLowerCase().contains(query.toLowerCase()) ??
              false;
        }).toList();
      }
    });
  }

  void _handleCustomSubcategory() {
    final text = _searchController.text.trim();
    if (text.isNotEmpty) {
      // Check if the text matches any existing subcategory
      final existingSubcategory = widget.items.firstWhere(
        (item) => item.name?.toLowerCase() == text.toLowerCase(),
        orElse: () => Subcategory(name: text), // Create a custom subcategory
      );

      if (_selectedItem?.name != text) {
        _update(() {
          _selectedItem = existingSubcategory;
        });
        widget.onChanged?.call(existingSubcategory);
      }
    }
  }
}
