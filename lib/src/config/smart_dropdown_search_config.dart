import 'package:flutter/material.dart';
import '../enums/search_mode.dart';

/// Configuration options for dropdown search behavior and styling.
class SmartDropdownSearchConfig {
  final bool enabled;
  final String hintText;
  final bool autoFocus;
  final Duration debounceDuration;
  final SearchMode searchMode;
  final Widget? searchIcon;
  final Widget? clearIcon;
  final InputDecoration? inputDecoration;
  final bool highlightMatches;
  final Color? highlightColor;
  final int minChars;
  final bool Function(dynamic item, String query)? customSearch;

  final FocusNode? searchFocusNode;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchCleared;

  const SmartDropdownSearchConfig({
    this.enabled = true,
    this.hintText = 'Search...',
    this.autoFocus = true,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.searchMode = SearchMode.contains,
    this.searchIcon,
    this.clearIcon,
    this.inputDecoration,
    this.highlightMatches = false,
    this.highlightColor,
    this.minChars = 0,
    this.customSearch,
    this.searchFocusNode,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchCleared,
  });

  SmartDropdownSearchConfig copyWith({
    bool? enabled,
    String? hintText,
    String? searchHintText,
    bool? autoFocus,
    Duration? debounceDuration,
    SearchMode? searchMode,
    Widget? searchIcon,
    Widget? clearIcon,
    InputDecoration? inputDecoration,
    bool? highlightMatches,
    Color? highlightColor,
    int? minChars,
    bool Function(dynamic item, String query)? customSearch,
    FocusNode? searchFocusNode,
    ValueChanged<String>? onSearchChanged,
    ValueChanged<String>? onSearchSubmitted,
    VoidCallback? onSearchCleared,
  }) {
    return SmartDropdownSearchConfig(
      enabled: enabled ?? this.enabled,
      hintText: searchHintText ?? hintText ?? this.hintText,
      autoFocus: autoFocus ?? this.autoFocus,
      debounceDuration: debounceDuration ?? this.debounceDuration,
      searchMode: searchMode ?? this.searchMode,
      searchIcon: searchIcon ?? this.searchIcon,
      clearIcon: clearIcon ?? this.clearIcon,
      inputDecoration: inputDecoration ?? this.inputDecoration,
      highlightMatches: highlightMatches ?? this.highlightMatches,
      highlightColor: highlightColor ?? this.highlightColor,
      minChars: minChars ?? this.minChars,
      customSearch: customSearch ?? this.customSearch,
      searchFocusNode: searchFocusNode ?? this.searchFocusNode,
      onSearchChanged: onSearchChanged ?? this.onSearchChanged,
      onSearchSubmitted: onSearchSubmitted ?? this.onSearchSubmitted,
      onSearchCleared: onSearchCleared ?? this.onSearchCleared,
    );
  }
}
