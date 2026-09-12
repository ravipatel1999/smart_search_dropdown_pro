import 'package:flutter/material.dart';
import 'smart_dropdown_theme_data.dart';

/// An [InheritedWidget] that provides [SmartDropdownThemeData] to descendant
/// dropdown widgets.
class SmartSearchDropdownTheme extends InheritedWidget {
  /// Theme data configuration.
  final SmartDropdownThemeData data;

  const SmartSearchDropdownTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Retrieves the nearest [SmartDropdownThemeData] from the widget tree.
  static SmartDropdownThemeData of(BuildContext context) {
    final SmartSearchDropdownTheme? theme =
        context.dependOnInheritedWidgetOfExactType<SmartSearchDropdownTheme>();
    return theme?.data ?? const SmartDropdownThemeData();
  }

  /// Retrieves [SmartDropdownThemeData] if available, without registering dependency.
  static SmartDropdownThemeData? maybeOf(BuildContext context) {
    final SmartSearchDropdownTheme? theme =
        context.dependOnInheritedWidgetOfExactType<SmartSearchDropdownTheme>();
    return theme?.data;
  }

  @override
  bool updateShouldNotify(SmartSearchDropdownTheme oldWidget) {
    return data != oldWidget.data;
  }
}
