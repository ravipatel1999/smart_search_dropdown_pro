import 'package:flutter/material.dart';
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
  final Widget Function(
      BuildContext context, dynamic item, VoidCallback? onRemove)? chipBuilder;
  final String Function(dynamic item)? chipLabelBuilder;
  final Widget Function(dynamic item)? chipAvatarBuilder;
  final Widget? chipDeleteIcon;
  final TextStyle? chipTextStyle;
  final Color? chipBackgroundColor;
  final BorderSide? chipBorder;
  final EdgeInsetsGeometry? chipPadding;
  final double chipSpacing;
  final double chipRunSpacing;
  final int? maxVisibleChips;
  final Widget Function(BuildContext context, int remainingCount)?
      overflowChipBuilder;

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
    this.chipBuilder,
    this.chipLabelBuilder,
    this.chipAvatarBuilder,
    this.chipDeleteIcon,
    this.chipTextStyle,
    this.chipBackgroundColor,
    this.chipBorder,
    this.chipPadding,
    this.chipSpacing = 6.0,
    this.chipRunSpacing = 6.0,
    this.maxVisibleChips,
    this.overflowChipBuilder,
  });

  bool get isMulti => mode == SelectionMode.multiple;

  SmartDropdownSelectionConfig copyWith({
    SelectionMode? mode,
    bool? showSelectAll,
    bool? showClearAll,
    String? selectAllText,
    String? clearAllText,
    int? maxSelections,
    int? minSelections,
    bool? showConfirmBar,
    String? cancelText,
    String? confirmText,
    bool? allowChipRemoval,
    Widget Function(BuildContext context, dynamic item, VoidCallback? onRemove)?
        chipBuilder,
    String Function(dynamic item)? chipLabelBuilder,
    Widget Function(dynamic item)? chipAvatarBuilder,
    Widget? chipDeleteIcon,
    TextStyle? chipTextStyle,
    Color? chipBackgroundColor,
    BorderSide? chipBorder,
    EdgeInsetsGeometry? chipPadding,
    double? chipSpacing,
    double? chipRunSpacing,
    int? maxVisibleChips,
    Widget Function(BuildContext context, int remainingCount)?
        overflowChipBuilder,
  }) {
    return SmartDropdownSelectionConfig(
      mode: mode ?? this.mode,
      showSelectAll: showSelectAll ?? this.showSelectAll,
      showClearAll: showClearAll ?? this.showClearAll,
      selectAllText: selectAllText ?? this.selectAllText,
      clearAllText: clearAllText ?? this.clearAllText,
      maxSelections: maxSelections ?? this.maxSelections,
      minSelections: minSelections ?? this.minSelections,
      showConfirmBar: showConfirmBar ?? this.showConfirmBar,
      cancelText: cancelText ?? this.cancelText,
      confirmText: confirmText ?? this.confirmText,
      allowChipRemoval: allowChipRemoval ?? this.allowChipRemoval,
      chipBuilder: chipBuilder ?? this.chipBuilder,
      chipLabelBuilder: chipLabelBuilder ?? this.chipLabelBuilder,
      chipAvatarBuilder: chipAvatarBuilder ?? this.chipAvatarBuilder,
      chipDeleteIcon: chipDeleteIcon ?? this.chipDeleteIcon,
      chipTextStyle: chipTextStyle ?? this.chipTextStyle,
      chipBackgroundColor: chipBackgroundColor ?? this.chipBackgroundColor,
      chipBorder: chipBorder ?? this.chipBorder,
      chipPadding: chipPadding ?? this.chipPadding,
      chipSpacing: chipSpacing ?? this.chipSpacing,
      chipRunSpacing: chipRunSpacing ?? this.chipRunSpacing,
      maxVisibleChips: maxVisibleChips ?? this.maxVisibleChips,
      overflowChipBuilder: overflowChipBuilder ?? this.overflowChipBuilder,
    );
  }
}
