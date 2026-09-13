# Smart Search Dropdown Pro

A highly flexible, production-ready, type-safe searchable dropdown component for Flutter applications. Provides a unified widget API to build single-select, multi-select, grouped, async API-powered, paginated, and adaptive responsive dropdown interfaces.

[![pub package](https://img.shields.io/pub/v/smart_search_dropdown_pro.svg)](https://pub.dev/packages/smart_search_dropdown_pro)
[![pub points](https://img.shields.io/pub/points/smart_search_dropdown_pro)](https://pub.dev/packages/smart_search_dropdown_pro/score)
[![popularity](https://img.shields.io/pub/popularity/smart_search_dropdown_pro)](https://pub.dev/packages/smart_search_dropdown_pro/score)
[![likes](https://img.shields.io/pub/likes/smart_search_dropdown_pro)](https://pub.dev/packages/smart_search_dropdown_pro/score)
[![GitHub Stars](https://img.shields.io/github/stars/ravipatel1999/smart_search_dropdown_pro)](https://github.com/ravipatel1999/smart_search_dropdown_pro)
[![GitHub Issues](https://img.shields.io/github/issues/ravipatel1999/smart_search_dropdown_pro)](https://github.com/ravipatel1999/smart_search_dropdown_pro/issues)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

---

## 📸 Package Showcase

![SmartSearchDropdown Pro Showcase](https://raw.githubusercontent.com/ravipatel1999/smart_search_dropdown_pro/main/assets/smart_search_dropdown_pro_showcase.png)

> **Asset Reference:** `assets/smart_search_dropdown_pro_showcase.png`
> *Demonstrates single selection, multi-select chips, grouped categories, status badges, mobile bottom sheets, and dark mode themes.*

---

## 💡 About Smart Search Dropdown Pro

Building dropdown inputs in Flutter often requires mixing multiple specialized packages when requirements grow to include search filtering, multi-selection chips, remote API fetching, or mobile bottom sheets.

`SmartSearchDropdownPro` consolidates these features into a single, cohesive generic component (`SmartSearchDropdown<T>`). Whether you need a standard Flutter searchable dropdown, a Flutter autocomplete dropdown, a Flutter multi-select dropdown with chip tags, or a server-side paginated list, this package provides a clean, declarative API.

### Key Highlights

- 🎯 **Single & Multi-Select**: Seamlessly switch between single value selection and multi-select chip tags.
- ⚡ **Type-Safe Generic (`<T>`)**: Directly handles custom Dart model classes, enums, numbers, and strings.
- 🔍 **Instant Search & Autocomplete**: Supports `contains`, `startsWith`, `fuzzy`, and `custom` search matching algorithms with debouncing.
- 🌐 **Async & Remote API Integration**: Built-in debounced searching, loading indicators, error views, and request handling for backend services.
- 📄 **Infinite Scroll Pagination**: Built-in `SmartDropdownPaginationConfig` to trigger paged data fetching on scroll.
- 📱 **Adaptive Responsive UI**: Automatically renders anchored popup menus on Desktop/Web/Tablet and BottomSheet or Modal Dialog on Mobile (<600px width).
- 📝 **Flutter Form Field Wrapper**: Integrated `SmartSearchDropdownFormField<T>` for Flutter `Form` validation and autovalidate modes.
- 🎮 **Programmatic Controller**: Control popup visibility, selections, and state programmatically via `SmartDropdownController<T>`.
- 🎨 **Material 3 & Dark Theme Ready**: Automatically inherits theme colors and typography from `Theme.of(context)` with optional `SmartDropdownThemeData` customization.

---

## 📦 Installation

Add `smart_search_dropdown_pro` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_search_dropdown_pro: ^1.0.5
```

Import the package entrypoint in your Flutter code:

```dart
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';
```

---

## 🚀 Quick Start

Here is a minimal Flutter search dropdown implementation:

```dart
import 'package:flutter/material.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';

class QuickStartExample extends StatefulWidget {
  const QuickStartExample({super.key});

  @override
  State<QuickStartExample> createState() => _QuickStartExampleState();
}

class _QuickStartExampleState extends State<QuickStartExample> {
  String? selectedHospital;

  final List<String> hospitals = const [
    'Sunshine Hospital',
    'Everest Hospital',
    'City Care Hospital',
    'Metro Health Center',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Search Dropdown')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SmartSearchDropdown<String>(
          items: hospitals,
          value: selectedHospital,
          hintText: 'Select Hospital',
          onChanged: (value) {
            setState(() {
              selectedHospital = value;
            });
          },
        ),
      ),
    );
  }
}
```

---

## 🎨 16 UI Variations

Explore how `SmartSearchDropdown<T>` accommodates different UI specifications using dedicated configuration objects.

### 1. Basic Searchable Dropdown
A clean single-select Flutter search dropdown:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 2. Searchable Dropdown with Icons
A Flutter dropdown with icons displayed alongside each item label:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  itemIconBuilder: (facility) => Icon(facility.icon),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 3. Searchable Dropdown with Descriptions
Display subtitle details for detailed item views:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  itemSubtitleBuilder: (facility) => facility.location,
  itemIconBuilder: (facility) => Icon(facility.icon),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 4. Searchable Dropdown with Logos / Avatars
A Flutter dropdown with avatars or image badges:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  itemAvatarBuilder: (facility) => CircleAvatar(
    radius: 14,
    child: Text(facility.name[0]),
  ),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 5. Grouped Dropdown
Organize items under category headers:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  groupBy: (facility) => facility.category,
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 6. Multi-Select Dropdown
A Flutter multi-select dropdown rendering choices as removable input chips:
```dart
SmartSearchDropdown<Facility>.multi(
  items: facilities,
  selectedItems: selectedFacilities,
  itemLabelBuilder: (facility) => facility.name,
  hintText: 'Select Facilities',
  onMultiChanged: (facilities) => setState(() => selectedFacilities = facilities),
)
```

### 7. Select All / Clear All
Enable batch actions inside the multi-select header:
```dart
SmartSearchDropdown<Facility>.multi(
  items: facilities,
  selectedItems: selectedFacilities,
  itemLabelBuilder: (facility) => facility.name,
  showSelectAll: true,
  showClearAll: true,
  hintText: 'Select Facilities',
  onMultiChanged: (facilities) => setState(() => selectedFacilities = facilities),
)
```

### 8. Recent & Popular Items
Pin frequently or recently selected items to the top of the popup:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  recent: SmartDropdownRecentConfig(
    enabled: true,
    recentItems: recentFacilities,
    popularItems: popularFacilities,
  ),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 9. Status / Tags
Attach status indicators or custom tags to list options:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  itemStatusBuilder: (facility) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.green.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      facility.status,
      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
    ),
  ),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 10. Infinite Scroll / Load More
A Flutter paginated dropdown fetching more items on scroll:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  pagination: SmartDropdownPaginationConfig(
    enabled: true,
    pageSize: 10,
    onLoadMore: (page) async {
      return await repository.fetchFacilities(page: page, pageSize: 10);
    },
  ),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 11. Create New Option
Allow users to create and select a new option on the fly:
```dart
SmartSearchDropdown<String>(
  items: facilityNames,
  value: selectedName,
  hintText: 'Type to search or create...',
  onCreateOption: (query) async {
    final created = await repository.createFacility(query);
    setState(() => facilityNames.add(created));
    return created;
  },
  onChanged: (name) => setState(() => selectedName = name),
)
```

### 12. Advanced Filters
Inject custom filter header widgets into the dropdown popup:
```dart
SmartSearchDropdown<Facility>(
  items: filteredFacilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  filters: SmartDropdownFilterConfig(
    enabled: true,
    builder: (context, controller) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          value: selectedCategory,
          isExpanded: true,
          items: categoryMenuItems,
          onChanged: (category) => setState(() => selectedCategory = category!),
        ),
      );
    },
  ),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 13. Rich Item Layout
Completely override the list item layout using `itemBuilder`:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  itemBuilder: (context, facility, state) {
    return ListTile(
      leading: Icon(facility.icon),
      title: Text(facility.name),
      subtitle: Text('${facility.category} • ${facility.location}'),
      trailing: state.isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
    );
  },
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 14. Dark Theme
A Flutter dark mode dropdown using ambient theme inheritance or explicit custom themes:
```dart
SmartSearchDropdownTheme(
  data: const SmartDropdownThemeData(
    surfaceColor: Color(0xFF1E293B),
    hoverColor: Color(0xFF334155),
    labelStyle: TextStyle(color: Colors.white),
  ),
  child: SmartSearchDropdown<Facility>(
    items: facilities,
    value: selectedFacility,
    itemLabelBuilder: (facility) => facility.name,
    hintText: 'Select Facility',
    onChanged: (facility) => setState(() => selectedFacility = facility),
  ),
)
```

### 15. Custom Empty / Error / Loading States
Customize fallback UI builders for empty queries, network errors, or loading indicators:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  emptyBuilder: (context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(24.0),
      child: Text('No matching facilities found'),
    ),
  ),
  errorBuilder: (context, error) => Center(
    child: Text('Error loading facilities: $error'),
  ),
  loadingBuilder: (context) => const Center(
    child: CircularProgressIndicator(),
  ),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 16. Responsive / Adaptive Presentation
A Flutter responsive dropdown adapting popup menus for desktop and bottom sheets for mobile screens:
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  popup: const SmartDropdownPopupConfig(
    presentation: DropdownPresentation.adaptive,
    mobileTitle: 'Select Facility',
  ),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

---

## 🛡️ Remote Search & Async Safety

Building production-grade remote search dropdowns requires handling complex asynchronous edge cases: network latency inversions, fast keystrokes, out-of-order responses, mid-pagination query changes, and component teardown.

`smart_search_dropdown_pro` includes a robust query generation architecture to guarantee UI and state consistency.

### 1. Monotonically Increasing Request Generation (`_searchGeneration`)
Debouncing alone is **not** enough to prevent stale network responses. If a user searches `"A"`, then searches `"AB"`, request `AB` may return in 100ms while slow request `A` returns in 600ms. Without generation protection, request `A` would overwrite `AB`'s fresh results.

With our request token mechanism:
- Every search start, clear, refresh, or retry increments `_searchGeneration`.
- When an API response completes, the dropdown checks:
  ```dart
  if (generation != _searchGeneration) {
    // Stale response silently dropped - will NEVER mutate current UI
    return;
  }
  ```
- The latest active search query **always wins**, regardless of network completion order.

### 2. Configurable Debounce & Query Normalization
Prevent flooding backend servers with an API call for every keystroke:
- **`debounceDuration`**: (Default `Duration(milliseconds: 300)`). Cancels and restarts timer on each keystroke.
- **`trimQuery`**: (Default `true`). Trims leading/trailing whitespace to prevent redundant searches.
- **`caseSensitive`**: (Default `false`). Avoids re-requesting the identical query if only casing changed.
- **Immediate Invalidation on Clear**: When the user taps the clear button, all pending debounce timers and in-flight searches are invalidated immediately.

### 3. Query-Aware Serialized Pagination
Infinite scrolling often leads to race conditions when users scroll rapidly or change queries while a page is in-flight:
- **Pagination Serialization**: Loading guards ensure that only one page request is active at any given moment. Rapid scroll events will never trigger multiple duplicate page 2 requests.
- **Session-Bound Pagination**: When the search query changes from `"flutter"` to `"flutter package"`, pagination state resets completely (`currentPage = 1`, `hasMore = true`, errors cleared). An in-flight Page 2 response for `"flutter"` will **never** be appended to `"flutter package"`.
- **Accurate Footers**: Loading spinners are shown *only* while actively loading the next page, never permanently remaining at the bottom when not loading or when all pages are exhausted.

### 4. Granular Error Handling & Retry
- **Initial Search Error**: Displays a clean error view with a **Retry** button that retries the active query without losing search context.
- **Pagination Error**: When Page 2 fails, existing Page 1 results **remain visible**, and a dedicated pagination error footer appears with a **Retry** button to retry Page 2 only.
- **Error Callbacks**: Optional `onSearchError` and `onPaginationError` callbacks for custom toast/snackbar notifications or telemetry.

### 5. Deduplication & Item Identity
If consecutive API pages return overlapping records, duplicate items are automatically filtered:
- **`itemIdExtractor`**: Provide an extractor function (e.g. `(item) => item.id`) for stable entity identity.
- **`preventDuplicates`**: (Default `true`). Automatically eliminates duplicate records across pages while preserving API result order.

### 6. Empty Query Behavior
Configure what happens when the search field is empty via `SearchEmptyQueryBehavior`:
- `SearchEmptyQueryBehavior.showInitialItems` (default): Displays static `items` list if provided.
- `SearchEmptyQueryBehavior.callRemoteApi`: Calls the remote API with `""` to fetch default/popular results.
- `SearchEmptyQueryBehavior.clearResults`: Clears all dropdown results until a query is entered.

---

### 🚀 Production-Grade Remote Paginated Search Example

```dart
SmartSearchDropdown<Facility>(
  itemLabelBuilder: (f) => f.name,
  itemSubtitleBuilder: (f) => '${f.category} • ${f.location}',
  itemIdExtractor: (f) => f.id, // Stable identity prevents duplicates across pages
  
  // 1. Paginated Remote Search Callback (receives query and 1-indexed page)
  asyncPaginatedSearch: (query, page) async {
    final response = await http.get(
      Uri.parse('https://api.example.com/facilities?q=$query&page=$page&limit=20'),
    );
    return parseFacilities(response.body);
  },

  // 2. Search & Debounce Configuration
  search: const SmartDropdownSearchConfig(
    hintText: 'Search facilities via remote API...',
    debounceDuration: Duration(milliseconds: 300),
    trimQuery: true,
    emptyQueryBehavior: SearchEmptyQueryBehavior.showInitialItems,
  ),

  // 3. Pagination Configuration
  pagination: SmartDropdownPaginationConfig(
    enabled: true,
    pageSize: 20,
    scrollThreshold: 250.0,
    preventDuplicates: true,
  ),

  // 4. Error Callbacks
  onSearchError: (error) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Search failed: $error')),
  ),
  onPaginationError: (error) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to load more facilities: $error')),
  ),

  hintText: 'Select Facility',
  onChanged: (facility) {
    setState(() => selectedFacility = facility);
  },
)
```

---

## 📝 Form Validation Integration

Wrap your dropdown in standard Flutter `Form` widgets using `SmartSearchDropdownFormField<T>`. It exposes standard Flutter `FormField` properties like `validator`, `onSaved`, and `autovalidateMode`.

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      SmartSearchDropdownFormField<Facility>(
        items: facilities,
        itemLabelBuilder: (facility) => facility.name,
        hintText: 'Select required facility',
        validator: (value) {
          if (value == null) {
            return 'Please select a facility to continue';
          }
          return null;
        },
        onSaved: (value) => savedFacility = value,
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
          }
        },
        child: const Text('Submit Form'),
      ),
    ],
  ),
)
```

---

## 🎮 Programmatic Controller API

Control dropdown overlay state programmatically using `SmartDropdownController<T>`:

```dart
final controller = SmartDropdownController<Facility>();

// Open dropdown popup programmatically
controller.open();

// Close dropdown popup programmatically
controller.close();

// Toggle open/close overlay state
controller.toggle();

// Select item programmatically
controller.select(facility);

// Deselect item programmatically
controller.deselect(facility);

// Select all items in multi-select mode
controller.selectAll(facilitiesList);

// Clear all selections
controller.clearAll();

// Update search query programmatically
controller.setSearchQuery('Everest');
```

---

## 🛠️ Public Package Classes & Architecture

Below are the key public classes provided by `smart_search_dropdown_pro`:

- **`SmartSearchDropdown<T>`**: The main widget for single and multi-selection searchable dropdowns.
- **`SmartSearchDropdownFormField<T>`**: FormField wrapper enabling Flutter `Form` validation.
- **`SmartDropdownController<T>`**: Controller for programmatic state manipulation and callback listening.
- **`SmartDropdownConfig<T>`**: Master configuration object aggregating sub-configurations.
- **`SmartDropdownSearchConfig`**: Search behavior settings (mode, debouncing, min characters, custom matching).
- **`SmartDropdownSelectionConfig`**: Selection mode settings (single/multiple, select all, clear all, max selections).
- **`SmartDropdownPopupConfig`**: Presentation layout settings (popup, menu, bottomSheet, dialog, adaptive, height, offset).
- **`SmartDropdownFilterConfig<T>`**: Custom header filter builder configuration.
- **`SmartDropdownPaginationConfig<T>`**: Infinite scroll pagination configuration and `onLoadMore` callbacks.
- **`SmartDropdownCreateOptionConfig<T>`**: Custom option creation configuration for unlisted queries.
- **`SmartDropdownRecentConfig<T>`**: Configurations for pinning recent and popular items.
- **`SmartDropdownThemeData`**: Custom theme configuration object for colors, text styles, padding, and borders.
- **`SmartSearchDropdownTheme`**: Inherited widget for providing `SmartDropdownThemeData` down the widget tree.

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
