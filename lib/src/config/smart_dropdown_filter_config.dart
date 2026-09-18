import 'package:flutter/material.dart';
import '../controllers/smart_dropdown_controller.dart';

/// Configuration options for dropdown filtering header UI.
class SmartDropdownFilterConfig<T> {
  final bool enabled;
  final Widget Function(
      BuildContext context, SmartDropdownController<T> controller)? builder;

  const SmartDropdownFilterConfig({
    this.enabled = false,
    this.builder,
  });

  SmartDropdownFilterConfig<T> copyWith({
    bool? enabled,
    Widget Function(
            BuildContext context, SmartDropdownController<T> controller)?
        builder,
  }) {
    return SmartDropdownFilterConfig<T>(
      enabled: enabled ?? this.enabled,
      builder: builder ?? this.builder,
    );
  }
}
