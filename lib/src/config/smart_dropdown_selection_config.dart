import '../enums/selection_mode.dart';

/// Configuration options for dropdown selection mode and controls.
class SmartDropdownSelectionConfig {
  final SelectionMode mode;
  final bool showSelectAll;
  final bool showClearAll;
  final String selectAllText;
  final String clearAllText;
  final int? maxSelections;
  final int? minSelections;
  final bool showConfirmBar;
  final String cancelText;
  final String confirmText;
  final bool allowChipRemoval;

  const SmartDropdownSelectionConfig({
    this.mode = SelectionMode.single,
    this.showSelectAll = true,
    this.showClearAll = true,
    this.selectAllText = 'Select All',
    this.clearAllText = 'Clear All',
    this.maxSelections,
    this.minSelections,
    this.showConfirmBar = false,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.allowChipRemoval = true,
  });

  bool get isMulti => mode == SelectionMode.multiple;
}
