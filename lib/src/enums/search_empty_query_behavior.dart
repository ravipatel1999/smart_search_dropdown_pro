/// Strategy for handling empty queries (`""`) in search dropdowns.
enum SearchEmptyQueryBehavior {
  /// Displays initial static items (or empty list if no items provided).
  /// This is the default backward-compatible behavior.
  showInitialItems,

  /// Calls the remote search API with an empty query string `""`.
  callRemoteApi,

  /// Clears all results when the search query is empty.
  clearResults,
}
