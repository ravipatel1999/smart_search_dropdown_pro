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
  });
}
