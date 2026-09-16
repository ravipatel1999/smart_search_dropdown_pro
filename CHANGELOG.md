## 1.0.8

- **Full Customization Upgrade**: Complete 46-phase component customization release.
- **Input Field & Labeling**: Native `InputDecoration` integration, `readOnly`, `autofocus`, `focusNode`, `required` indicator builder, `onFocus`, and `onBlur`.
- **Chip Customization**: Added `chipBuilder`, `chipLabelBuilder`, `chipAvatarBuilder`, `chipDeleteIcon`, `chipTextStyle`, `chipBackgroundColor`, `chipBorder`, `chipPadding`, `maxVisibleChips`, `overflowChipBuilder`.
- **Search & Popup Control**: Added search focus nodes, search callbacks (`onSearchChanged`, `onSearchSubmitted`, `onSearchCleared`), min/max sizing bounds, barrier color, and dismissal triggers (`closeOnSelect`, `closeOnOutsideTap`, `closeOnEscape`).
- **Controller Expansion**: Added convenience helper methods (`clear()`, `clearSearch()`, `refresh()`, `reload()`, `loadMore()`, `focusSearch()`, `blurSearch()`).
- **Stale Response Protection**: Monotonically increasing `_searchGeneration` request token mechanism to eliminate async response race conditions.
- **Healthcare Patient Demo**: Included interactive Patient EHR search demo (`patient_demo.dart`) with MRN search, paged async loader, and race condition tests.
- **Comprehensive Verification**: 100% passing tests and 0 `flutter analyze` issues.

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
