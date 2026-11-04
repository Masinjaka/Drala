import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'custom_dropdown_overlay.dart';
part 'custom_dropdown_options.dart';
part 'custom_dropdown_field.dart';

class CustomDropdown extends ConsumerStatefulWidget {
  const CustomDropdown({
    super.key,
    required this.title,
    this.hint,
    required this.items,
    this.onChanged,
    this.validator,
    this.selectedValue,
    this.enabled = true,
    this.showEmojis = true,
    this.showColors = false,
  });

  final Widget title;
  final String? hint;
  final List<Category> items;
  final void Function(Category?)? onChanged;
  final Map<String, String>? validator;
  final Category? selectedValue;
  final bool enabled;
  final bool showEmojis;
  final bool showColors;

  @override
  ConsumerState<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends ConsumerState<CustomDropdown>
    with SingleTickerProviderStateMixin {
  Category? _selectedItem;
  bool _isDropdownOpen = false;
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _dropdownAnimation;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedValue;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 200), // Slightly longer for better curve effect
    );

    // Create curved animation with fast-out-slow-in
    _dropdownAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCirc,
    );
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      _selectedItem = widget.selectedValue;
    }

    // Close dropdown if the widget becomes disabled or items change
    if ((!widget.enabled || widget.items.isEmpty) && _isDropdownOpen) {
      _removeOverlay();
    }
  }

  @override
  void dispose() {
    // Immediately remove overlay without animation to avoid setState after dispose
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isDropdownOpen = false; // Set state directly without setState
    }
    _animationController.dispose();
    super.dispose();
  }

  String? validate(String type, String? error, Category? value) {
    switch (type) {
      case 'required':
        return value == null ? (error ?? "Ce champ est requis") : null;
      default:
        return null;
    }
  }

  void _toggleDropdown() {
    if (!widget.enabled || widget.items.isEmpty) return;

    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _createOverlay();
    }
  }

  void _createOverlay() {
    final RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = _createOverlayEntry(offset, size);
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _isDropdownOpen = true;
    });

    _animationController.forward();
  }

  void _removeOverlay() async {
    if (_overlayEntry != null) {
      // Check if widget is still mounted before starting animation
      if (mounted) {
        await _animationController.reverse();
      }
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    // Double check mounted state after async operation
    if (mounted) {
      setState(() {
        _isDropdownOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => _buildContent(context);
  void _update(VoidCallback action) => setState(action);
}
