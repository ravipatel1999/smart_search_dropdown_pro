import 'package:flutter/material.dart';
import 'smart_dropdown_tokens.dart';

/// Customizable theme parameters specifically for [SmartSearchDropdown].
///
/// When properties are null, the widget automatically inherits styles from
/// the ambient Flutter [Theme.of(context)].
@immutable
class SmartDropdownThemeData {
  final Color? backgroundColor;
  final Color? surfaceColor;
  final Color? primaryColor;
  final Color? hoverColor;
  final Color? selectedColor;
  final Color? disabledColor;
  final Color? errorColor;
  final Color? shadowColor;
  final Color? dividerColor;

  final TextStyle? labelStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? hintStyle;
  final TextStyle? groupHeaderStyle;
  final TextStyle? searchTextStyle;

  final double? elevation;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final BorderSide? focusedBorder;
  final BorderSide? errorBorder;

  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? itemPadding;
  final EdgeInsetsGeometry? searchPadding;

  final IconThemeData? iconTheme;
  final ChipThemeData? chipTheme;

  const SmartDropdownThemeData({
    this.backgroundColor,
    this.surfaceColor,
    this.primaryColor,
    this.hoverColor,
    this.selectedColor,
    this.disabledColor,
    this.errorColor,
    this.shadowColor,
    this.dividerColor,
    this.labelStyle,
    this.subtitleStyle,
    this.hintStyle,
    this.groupHeaderStyle,
    this.searchTextStyle,
    this.elevation,
    this.borderRadius,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.contentPadding,
    this.itemPadding,
    this.searchPadding,
    this.iconTheme,
    this.chipTheme,
  });

  /// Resolves the effective background color given [BuildContext].
  Color getEffectiveBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;
    final theme = Theme.of(context);
    return theme.colorScheme.surface;
  }

  /// Resolves effective primary color.
  Color getEffectivePrimaryColor(BuildContext context) {
    if (primaryColor != null) return primaryColor!;
    return Theme.of(context).colorScheme.primary;
  }

  /// Resolves effective selected item tile background color.
  Color getEffectiveSelectedColor(BuildContext context) {
    if (selectedColor != null) return selectedColor!;
    final theme = Theme.of(context);
    return theme.colorScheme.primaryContainer.withValues(alpha: 0.35);
  }

  /// Resolves effective border radius.
  BorderRadius getEffectiveBorderRadius() {
    return borderRadius ?? BorderRadius.circular(SmartDropdownTokens.radiusM);
  }

  /// Creates a copy of this theme data with updated values.
  SmartDropdownThemeData copyWith({
    Color? backgroundColor,
    Color? surfaceColor,
    Color? primaryColor,
    Color? hoverColor,
    Color? selectedColor,
    Color? disabledColor,
    Color? errorColor,
    Color? shadowColor,
    Color? dividerColor,
    TextStyle? labelStyle,
    TextStyle? subtitleStyle,
    TextStyle? hintStyle,
    TextStyle? groupHeaderStyle,
    TextStyle? searchTextStyle,
    double? elevation,
    BorderRadius? borderRadius,
    BorderSide? border,
    BorderSide? focusedBorder,
    BorderSide? errorBorder,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? itemPadding,
    EdgeInsetsGeometry? searchPadding,
    IconThemeData? iconTheme,
    ChipThemeData? chipTheme,
  }) {
    return SmartDropdownThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      primaryColor: primaryColor ?? this.primaryColor,
      hoverColor: hoverColor ?? this.hoverColor,
      selectedColor: selectedColor ?? this.selectedColor,
      disabledColor: disabledColor ?? this.disabledColor,
      errorColor: errorColor ?? this.errorColor,
      shadowColor: shadowColor ?? this.shadowColor,
      dividerColor: dividerColor ?? this.dividerColor,
      labelStyle: labelStyle ?? this.labelStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      groupHeaderStyle: groupHeaderStyle ?? this.groupHeaderStyle,
      searchTextStyle: searchTextStyle ?? this.searchTextStyle,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      contentPadding: contentPadding ?? this.contentPadding,
      itemPadding: itemPadding ?? this.itemPadding,
      searchPadding: searchPadding ?? this.searchPadding,
      iconTheme: iconTheme ?? this.iconTheme,
      chipTheme: chipTheme ?? this.chipTheme,
    );
  }
}
