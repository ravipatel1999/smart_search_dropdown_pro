/// Contains runtime contextual state of a single dropdown item when rendering in [itemBuilder].
class SmartDropdownItemState {
  /// Index of the item in the list.
  final int index;

  /// Whether this item is currently selected.
  final bool isSelected;

  /// Whether this item is currently highlighted or focused via keyboard navigation.
  final bool isFocused;

  /// Whether this item is hovered by mouse.
  final bool isHovered;

  /// Whether this item is currently pressed.
  final bool isPressed;

  /// Whether this item is disabled.
  final bool isDisabled;

  /// The active search query string.
  final String searchQuery;

  /// Alias for [isFocused] to indicate keyboard or hover highlight state.
  bool get isHighlighted => isFocused || isHovered;

  const SmartDropdownItemState({
    required this.index,
    required this.isSelected,
    this.isFocused = false,
    this.isHovered = false,
    this.isPressed = false,
    this.isDisabled = false,
    this.searchQuery = '',
  });
}
