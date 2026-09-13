## 1.0.7

- **Production-Grade Remote Search & Async Race Condition Immunity:**
  - Implemented monotonic generation token system (`_searchGeneration`) dropping stale out-of-order network responses.
  - Cancelled debouncers immediately on query change, search clear, and dropdown disposal.
  - Added `SearchEmptyQueryBehavior` (`showInitialItems`, `callRemoteApi`, `clearResults`).
- **Serialized Pagination & Deduplication:**
  - Strictly serialized page loading to prevent concurrent or duplicate page requests.
  - Added `preventDuplicates` and `itemIdExtractor` to deduplicate items across pages.
  - Added `onLoadMoreWithQuery` callback supporting query-aware pagination.
  - Prevented in-flight page responses of previous searches from contaminating new queries.
- **Enhanced Error Handling, Controller & Accessibility:**
  - Separated initial load error from inline pagination error with retry button footer.
  - Added `retry()`, `retryPagination()`, and `refresh()` methods on `SmartDropdownController`.
  - Added keyboard navigation support (`ArrowUp`, `ArrowDown`, `Enter`, `Escape`).
  - Added comprehensive 12-case concurrency and race condition test suite.

## 1.0.6

- **Production-Grade Remote Search & Race Condition Safety:**
  - Implemented monotonic generation token system (`_searchGeneration`) dropping stale out-of-order network responses.
  - Cancelled debouncers immediately on query change, search clear, and dropdown disposal.
  - Added `SearchEmptyQueryBehavior` (`showInitialItems`, `callRemoteApi`, `clearResults`).
- **Serialized Pagination & Deduplication:**
  - Strictly serialized page loading to prevent concurrent or duplicate page requests.
  - Added `preventDuplicates` and `itemIdExtractor` to deduplicate items across pages.
  - Added `onLoadMoreWithQuery` callback supporting query-aware pagination.
  - Prevented in-flight page responses of previous searches from contaminating new queries.
- **Enhanced Error Handling & Controller:**
  - Separated initial load error from inline pagination error with retry button footer.
  - Added `retry()`, `retryPagination()`, and `refresh()` methods on `SmartDropdownController`.
  - Added keyboard navigation support (`ArrowUp`, `ArrowDown`, `Enter`, `Escape`).
  - Added full 12-case concurrency and race condition test suite.

## 1.0.5

- Optimized `pubspec.yaml` description length (175 characters) to comply with pub.dev Pana analysis rules and achieve 160/160 pub points.

## 1.0.4

- Improved pub.dev package discoverability metadata.
- Added optimized pub.dev topics.
- Improved README documentation and search relevance.
- Improved documentation for API search and pagination.
- Improved package showcase documentation.

## 1.0.3

- Added showcase preview image (`assets/smart_search_dropdown_pro_showcase.png`) to README.
- Renamed package to `smart_search_dropdown_pro`.

## 1.0.0

- Initial release of `smart_search_dropdown_pro`.
- Flexible generic `<T>` searchable dropdown system for pub.dev.
- Support for 16 design variations out of the box.
- Universal single and multi-selection modes (`SmartSearchDropdown.multi`).
- Built-in search algorithms: contains, startsWith, fuzzy, and custom search.
- Remote API search with automatic debouncing, cancellation, loading, and error states.
- Infinite scroll pagination support (`SmartDropdownPaginationConfig`).
- Adaptive responsive layout engine (Popup, Menu, BottomSheet, Dialog, Adaptive).
- Automatic Flutter ThemeData inheritance (Light / Dark mode, Material 3).
- Form field wrapper (`SmartSearchDropdownFormField`).
- Programmatic state controller (`SmartDropdownController`).
- Comprehensive unit and widget test suite.
