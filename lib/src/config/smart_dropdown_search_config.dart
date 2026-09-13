import 'package:flutter/material.dart';
import '../enums/search_empty_query_behavior.dart';
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

  /// Whether to trim leading and trailing whitespace from the search query.
  final bool trimQuery;

  /// Whether search query comparison for duplicate detection is case-sensitive.
  final bool caseSensitive;

  /// Defines behavior when the search query is empty.
  final SearchEmptyQueryBehavior emptyQueryBehavior;

  /// Whether to output debug logs during search operations and race conditions.
  final bool logDebug;

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
    this.trimQuery = true,
    this.caseSensitive = false,
    this.emptyQueryBehavior = SearchEmptyQueryBehavior.showInitialItems,
    this.logDebug = false,
  });

  SmartDropdownSearchConfig copyWith({
    bool? enabled,
    String? hintText,
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
    bool? trimQuery,
    bool? caseSensitive,
    SearchEmptyQueryBehavior? emptyQueryBehavior,
    bool? logDebug,
  }) {
    return SmartDropdownSearchConfig(
      enabled: enabled ?? this.enabled,
      hintText: hintText ?? this.hintText,
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
      trimQuery: trimQuery ?? this.trimQuery,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      emptyQueryBehavior: emptyQueryBehavior ?? this.emptyQueryBehavior,
      logDebug: logDebug ?? this.logDebug,
    );
  }
}
