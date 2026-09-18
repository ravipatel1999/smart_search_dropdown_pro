# Changelog

All notable changes to this package are documented here.

## 1.0.9

### ✨ New

- Added a more developer-friendly API for common dropdown features.
- Added simple boolean options for enabling/disabling common features.
- Added improved TextFormField-style customization.
- Added broader InputDecoration support.
- Added improved field customization for labels, hints, helpers, errors, prefixes, suffixes, borders, and fill styles.
- Added improved search field customization.
- Added improved selected-item customization.
- Added enhanced item builders and item state support.
- Added improved multi-select customization.
- Added customizable selection chips.
- Added improved dropdown icon and clear button customization.
- Added enhanced popup customization.
- Added popup header and footer customization.
- Added improved responsive and adaptive presentation options.
- Added improved mobile, web, and desktop customization.
- Added enhanced loading, empty, and error state builders.
- Added improved retry handling.
- Added improved async search handling.
- Added improved search and pagination lifecycle handling.
- Added improved pagination configuration.
- Added configurable API page size support.
- Added improved duplicate prevention for paginated results.
- Added improved grouping customization.
- Added improved recent and popular item customization.
- Added improved create-new-option customization.
- Added improved filter customization.
- Added improved FormField integration.
- Added improved controller capabilities.
- Added improved theme integration.
- Added improved dark mode support.
- Added improved keyboard navigation and accessibility support.
- Added improved RTL support.

### 🌍 Documentation

- Reworked package examples to be generic and globally applicable.
- Removed healthcare-specific examples as the primary usage examples.
- Added developer-focused examples using countries, products, users, frameworks, cities, brands, and other generic data.
- Simplified documentation with beginner-friendly examples.
- Added simple usage examples before advanced configuration examples.
- Added boolean feature-toggle examples for common functionality.
- Improved API documentation and configuration explanations.
- Added copy-paste-ready examples for major features.
- Improved pagination and remote API documentation.
- Improved FormField and controller documentation.
- Improved responsive, theme, accessibility, and customization documentation.
- Updated example application as a global developer playground.

### 🧪 Testing

- Expanded widget and interaction tests.
- Added coverage for customization options.
- Added search and pagination behavior tests.
- Added async request lifecycle and race-condition tests.
- Added multi-select and FormField validation tests.
- Added responsive and theme-related tests.
- Improved disposal and lifecycle safety tests.

### 🔧 Improvements

- Improved developer experience.
- Improved API consistency.
- Improved default UI behavior.
- Improved Flutter ThemeData integration.
- Improved performance and rebuild behavior.
- Improved async lifecycle safety.
- Improved package documentation quality.
- Improved example application usability.

### 🔒 Compatibility

- Existing public APIs are preserved wherever possible.
- Existing searchable dropdown functionality remains supported.
- Existing async search and pagination functionality remains supported.

## 1.0.5

- Optimized `pubspec.yaml` description length (172 characters) to comply with pub.dev Pana analysis rules and achieve maximum pub points.

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
