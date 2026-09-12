import 'package:flutter/material.dart';
import '../enums/search_mode.dart';

/// Text search matching and substring highlighting helper functions.
abstract class SearchUtils {
  /// Evaluates whether [label] matches [query] given the [SearchMode].
  static bool matches({
    required String label,
    required String query,
    required SearchMode searchMode,
  }) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return true;

    final cleanLabel = label.toLowerCase();

    switch (searchMode) {
      case SearchMode.startsWith:
        return cleanLabel.startsWith(cleanQuery);
      case SearchMode.contains:
        return cleanLabel.contains(cleanQuery);
      case SearchMode.fuzzy:
        return _fuzzyMatch(cleanLabel, cleanQuery);
      case SearchMode.custom:
        return cleanLabel.contains(cleanQuery);
    }
  }

  /// Basic fuzzy matching checking character sequence presence in order.
  static bool _fuzzyMatch(String label, String query) {
    int labelIndex = 0;
    int queryIndex = 0;

    while (labelIndex < label.length && queryIndex < query.length) {
      if (label[labelIndex] == query[queryIndex]) {
        queryIndex++;
      }
      labelIndex++;
    }

    return queryIndex == query.length;
  }

  /// Builds a [RichText] widget with highlighted matching query substrings.
  static Widget buildHighlightedText({
    required String text,
    required String query,
    required TextStyle baseStyle,
    required Color highlightColor,
  }) {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final lowercaseText = text.toLowerCase();
    final lowercaseQuery = cleanQuery.toLowerCase();

    final matches = <TextSpan>[];
    int start = 0;
    int index = lowercaseText.indexOf(lowercaseQuery);

    while (index != -1) {
      if (index > start) {
        matches.add(TextSpan(
          text: text.substring(start, index),
          style: baseStyle,
        ));
      }

      final matchEnd = index + cleanQuery.length;
      matches.add(TextSpan(
        text: text.substring(index, matchEnd),
        style: baseStyle.copyWith(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = matchEnd;
      index = lowercaseText.indexOf(lowercaseQuery, start);
    }

    if (start < text.length) {
      matches.add(TextSpan(
        text: text.substring(start),
        style: baseStyle,
      ));
    }

    return RichText(
      text: TextSpan(children: matches),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
