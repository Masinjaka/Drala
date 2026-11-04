part of 'custom_dropdown.dart';

extension _CustomDropdownOptions on _CustomDropdownState {
  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Text(
        'Aucune catégorie disponible',
        style: AppTextStyle(AppTextRole.input,
            color:
                Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
            fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildDropdownItems() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final category = widget.items[index];
        final isSelected = _selectedItem == category;

        return InkWell(
          onTap: () {
            _update(() {
              _selectedItem = category;
            });
            widget.onChanged?.call(category);
            _removeOverlay();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            child: Row(
              children: [
                if (widget.showEmojis)
                  CategoryIcon(
                      iconKey: category.iconKey,
                      emoji: category.emoji,
                      colorHex: category.color,
                      size: 18,
                      backgroundColor: Theme.of(context).cardColor),
                if (widget.showEmojis) SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category.name ?? 'Catégorie sans nom',
                    style: AppTextStyle(AppTextRole.input,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: AppIconForeground.resolve(
                      context,
                      Theme.of(context).textTheme.bodyLarge?.color ??
                          Theme.of(context).colorScheme.onSurface,
                    ),
                    size: 18,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
