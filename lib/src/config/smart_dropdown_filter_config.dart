import 'package:flutter/material.dart';
import '../controllers/smart_dropdown_controller.dart';

/// Configuration for advanced filters displayed inside the dropdown header.
@immutable
class SmartDropdownFilterConfig<T> {
  /// Whether advanced filter bar is enabled.
  final bool enabled;

  /// Custom widget builder for rendering filter controls above search bar.
  final Widget Function(BuildContext context, SmartDropdownController<T> controller)? builder;

  const SmartDropdownFilterConfig({
    this.enabled = false,
    this.builder,
  });

  SmartDropdownFilterConfig<T> copyWith({
    bool? enabled,
    Widget Function(BuildContext context, SmartDropdownController<T> controller)? builder,
  }) {
    return SmartDropdownFilterConfig<T>(
      enabled: enabled ?? this.enabled,
      builder: builder ?? this.builder,
    );
  }
}
