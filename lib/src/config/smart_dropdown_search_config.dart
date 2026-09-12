import 'package:flutter/material.dart';
import '../enums/search_mode.dart';
import '../theme/smart_dropdown_tokens.dart';

/// Configuration options for dropdown search behavior and UI.
@immutable
class SmartDropdownSearchConfig {
  /// Whether search capability is enabled.
  final bool enabled;

  /// Placeholder hint text in the search input.
  final String hintText;

  /// Built-in search mode algorithm.
  final SearchMode searchMode;

  /// Debounce duration before triggering search callbacks / async filtering.
  final Duration debounceDuration;

  /// Minimum characters required in search input before executing search.
  final int minChars;

  /// Whether to automatically focus the search text field when popup opens.
  final bool autoFocus;

  /// Whether to visually highlight substring matches in item labels.
  final bool highlightMatches;

  /// Color used for highlighting matched search text substrings.
  final Color? highlightColor;

  /// Custom search filter function: returns true if item matches query.
  final bool Function(dynamic item, String query)? customSearch;

  /// Leading icon inside search text field.
  final Widget? searchIcon;

  /// Clear button icon inside search field.
  final Widget? clearIcon;

  /// Custom decoration for search text input.
  final InputDecoration? inputDecoration;

  const SmartDropdownSearchConfig({
    this.enabled = true,
    this.hintText = 'Search...',
    this.searchMode = SearchMode.contains,
    this.debounceDuration = SmartDropdownTokens.searchDebounce,
    this.minChars = 0,
    this.autoFocus = true,
    this.highlightMatches = false,
    this.highlightColor,
    this.customSearch,
    this.searchIcon,
    this.clearIcon,
    this.inputDecoration,
  });

  SmartDropdownSearchConfig copyWith({
    bool? enabled,
    String? hintText,
    SearchMode? searchMode,
    Duration? debounceDuration,
    int? minChars,
    bool? autoFocus,
    bool? highlightMatches,
    Color? highlightColor,
    bool Function(dynamic item, String query)? customSearch,
    Widget? searchIcon,
    Widget? clearIcon,
    InputDecoration? inputDecoration,
  }) {
    return SmartDropdownSearchConfig(
      enabled: enabled ?? this.enabled,
      hintText: hintText ?? this.hintText,
      searchMode: searchMode ?? this.searchMode,
      debounceDuration: debounceDuration ?? this.debounceDuration,
      minChars: minChars ?? this.minChars,
      autoFocus: autoFocus ?? this.autoFocus,
      highlightMatches: highlightMatches ?? this.highlightMatches,
      highlightColor: highlightColor ?? this.highlightColor,
      customSearch: customSearch ?? this.customSearch,
      searchIcon: searchIcon ?? this.searchIcon,
      clearIcon: clearIcon ?? this.clearIcon,
      inputDecoration: inputDecoration ?? this.inputDecoration,
    );
  }
}
