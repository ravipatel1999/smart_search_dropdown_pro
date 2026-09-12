import 'package:flutter/material.dart';

/// Configuration options for creating new options on the fly.
class SmartDropdownCreateOptionConfig<T> {
  final bool enabled;
  final Future<T?> Function(String query)? onCreate;
  final String Function(String query)? createLabelBuilder;
  final Widget Function(BuildContext context, String query)? builder;

  const SmartDropdownCreateOptionConfig({
    this.enabled = false,
    this.onCreate,
    this.createLabelBuilder,
    this.builder,
  });

  SmartDropdownCreateOptionConfig<T> copyWith({
    bool? enabled,
    Future<T?> Function(String query)? onCreate,
    String Function(String query)? createLabelBuilder,
    Widget Function(BuildContext context, String query)? builder,
  }) {
    return SmartDropdownCreateOptionConfig<T>(
      enabled: enabled ?? this.enabled,
      onCreate: onCreate ?? this.onCreate,
      createLabelBuilder: createLabelBuilder ?? this.createLabelBuilder,
      builder: builder ?? this.builder,
    );
  }
}
