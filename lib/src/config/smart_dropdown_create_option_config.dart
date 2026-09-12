import 'package:flutter/material.dart';

/// Configuration for creating a new option on the fly when query doesn't match items.
@immutable
class SmartDropdownCreateOptionConfig<T> {
  /// Whether option creation is enabled.
  final bool enabled;

  /// Async callback executed when developer/user clicks the create option action.
  final Future<T?> Function(String query)? onCreate;

  /// Custom builder for rendering the "+ Create 'Query'" tile.
  final Widget Function(BuildContext context, String query)? builder;

  const SmartDropdownCreateOptionConfig({
    this.enabled = false,
    this.onCreate,
    this.builder,
  });

  SmartDropdownCreateOptionConfig<T> copyWith({
    bool? enabled,
    Future<T?> Function(String query)? onCreate,
    Widget Function(BuildContext context, String query)? builder,
  }) {
    return SmartDropdownCreateOptionConfig<T>(
      enabled: enabled ?? this.enabled,
      onCreate: onCreate ?? this.onCreate,
      builder: builder ?? this.builder,
    );
  }
}
