import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/features/categories/domain/models/subcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

part 'custom_subcategory_search.dart';
part 'custom_subcategory_options.dart';
part 'custom_subcategory_field.dart';

class CustomSubcategoryDropdown extends ConsumerStatefulWidget {
  const CustomSubcategoryDropdown({
    super.key,
    required this.title,
    this.hint,
    required this.items,
    this.onChanged,
    this.validator,
    this.selectedValue,
    this.enabled = true,
    this.onTap,
  });

  final Widget title;
  final String? hint;
  final List<Subcategory> items;
  final void Function(Subcategory?)? onChanged;
  final Map<String, String>? validator;
  final Subcategory? selectedValue;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  ConsumerState<CustomSubcategoryDropdown> createState() =>
      _CustomSubcategoryDropdownState();
}

class _CustomSubcategoryDropdownState
    extends ConsumerState<CustomSubcategoryDropdown>
    with SingleTickerProviderStateMixin {
  Subcategory? _selectedItem;
  bool _isDropdownOpen = false;
  late AnimationController _animationController;
  late Animation<double> _dropdownAnimation;
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  List<Subcategory> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedValue;
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _filteredItems = widget.items;

    // Set initial text if there's a selected value
    if (_selectedItem != null) {
      _searchController.text = _selectedItem!.name ?? '';
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _dropdownAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCirc,
    );

    // Listen to search text changes
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(CustomSubcategoryDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      _selectedItem = widget.selectedValue;
      if (_selectedItem != null) {
        _searchController.text = _selectedItem!.name ?? '';
      } else {
        _searchController.clear();
      }
    }

    // Update filtered items when widget items change
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
      _filterItems(_searchController.text);
    }

    if ((!widget.enabled || widget.items.isEmpty) && _isDropdownOpen) {
      _closeDropdown();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _focusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String? validate(String type, String? error, Subcategory? value) {
    switch (type) {
      case 'required':
        return value == null ? (error ?? "Ce champ est requis") : null;
      default:
        return null;
    }
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;

    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      // Call onTap callback before showing dropdown
      widget.onTap?.call();
      _focusNode.requestFocus();
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() {
      _isDropdownOpen = true;
    });
    _animationController.forward();
  }

  void _closeDropdown() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isDropdownOpen = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => _buildContent(context);
  void _update(VoidCallback action) => setState(action);
}
