part of 'custom_dropdown.dart';

extension _CustomDropdownOverlay on _CustomDropdownState {
  OverlayEntry _createOverlayEntry(Offset offset, Size size) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Invisible barrier to detect clicks outside
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Actual dropdown
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height,
            width: size.width,
            child: AnimatedBuilder(
              animation: _dropdownAnimation,
              builder: (context, child) {
                // Create a "drop down" effect by scaling from top and sliding down
                final scaleY = _dropdownAnimation.value;
                final slideOffset = (1 - _dropdownAnimation.value) *
                    -20; // Slide down from above

                return Transform.translate(
                  offset: Offset(0, slideOffset),
                  child: Transform.scale(
                    scaleY: scaleY,
                    alignment: Alignment.topCenter, // Scale from the top edge
                    child: Opacity(
                      opacity: _dropdownAnimation.value,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: 320, // Limit height to 40% of screen
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                    (0.1 * _dropdownAnimation.value * 255)
                                        .toInt()),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            child: widget.items.isEmpty
                                ? _buildEmptyState()
                                : _buildDropdownItems(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
