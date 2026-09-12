/// Defines the built-in search matching algorithms.
enum SearchMode {
  /// Matches items if label contains search query anywhere (case-insensitive).
  contains,

  /// Matches items if label starts with search query (case-insensitive).
  startsWith,

  /// Fuzzy matching based on sub-sequence and distance.
  fuzzy,

  /// Custom search filter logic specified by developer.
  custom,
}
