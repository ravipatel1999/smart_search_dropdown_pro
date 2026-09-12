import 'package:flutter/material.dart';
import '../enums/selection_mode.dart';

/// Configuration options for single or multi-item selection behavior.
@immutable
class SmartDropdownSelectionConfig {
  /// Selection mode (single or multiple).
  final SelectionMode mode;

  /// Maximum allowed selections in multi-select mode.
  final int? maxSelections;

  /// Minimum required selections in multi-select mode.
  final int? minSelections;

  /// Whether to display a 'Select All' toggle in multi-select mode.
  final bool showSelectAll;

  /// Whether to display a 'Clear All' action in multi-select mode.
  final bool showClearAll;

  /// Label text for 'Select All'.
  final String selectAllText;

  /// Label text for 'Clear All'.
  final String clearAllText;

  /// Label text for Confirm action button in multi-select popup.
  final String confirmText;

  /// Label text for Cancel action button in multi-select popup.
  final String cancelText;

  /// Whether to show a confirm/cancel action footer bar in multi-select mode.
  final bool showConfirmBar;

  /// Whether to allow removing selected chips directly from the trigger field.
  final bool allowChipRemoval;

  const SmartDropdownSelectionConfig({
    this.mode = SelectionMode.single,
    this.maxSelections,
    this.minSelections,
    this.showSelectAll = false,
    this.showClearAll = false,
    this.selectAllText = 'Select All',
    this.clearAllText = 'Clear All',
    this.confirmText = 'Apply',
    this.cancelText = 'Cancel',
    this.showConfirmBar = false,
    this.allowChipRemoval = true,
  });

  bool get isMulti => mode == SelectionMode.multiple;

  SmartDropdownSelectionConfig copyWith({
    SelectionMode? mode,
    int? maxSelections,
    int? minSelections,
    bool? showSelectAll,
    bool? showClearAll,
    String? selectAllText,
    String? clearAllText,
    String? confirmText,
    String? cancelText,
    bool? showConfirmBar,
    bool? allowChipRemoval,
  }) {
    return SmartDropdownSelectionConfig(
      mode: mode ?? this.mode,
      maxSelections: maxSelections ?? this.maxSelections,
      minSelections: minSelections ?? this.minSelections,
      showSelectAll: showSelectAll ?? this.showSelectAll,
      showClearAll: showClearAll ?? this.showClearAll,
      selectAllText: selectAllText ?? this.selectAllText,
      clearAllText: clearAllText ?? this.clearAllText,
      confirmText: confirmText ?? this.confirmText,
      cancelText: cancelText ?? this.cancelText,
      showConfirmBar: showConfirmBar ?? this.showConfirmBar,
      allowChipRemoval: allowChipRemoval ?? this.allowChipRemoval,
    );
  }
}
