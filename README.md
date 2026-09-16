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
  smart_search_dropdown_pro: ^1.0.8
```

Import the package entrypoint in your Flutter code:

```dart
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';
```

---

## 📝 TextFormField & InputDecoration Parity

`SmartSearchDropdown` seamlessly integrates with native Flutter `InputDecoration`. You can specify labels, icons, borders, helper text, and fill colors just like a standard `TextFormField`.

```dart
SmartSearchDropdown<Patient>(
  decoration: const InputDecoration(
    labelText: 'Patient Name *',
    hintText: 'Search patient by MRN or Name...',
    prefixIcon: Icon(Icons.person_search),
    suffixIcon: Icon(Icons.arrow_drop_down_circle),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  items: patients,
  itemLabelBuilder: (patient) => patient.name,
  itemSubtitleBuilder: (patient) => 'MRN: ${patient.mrn} • ${patient.primaryCondition}',
  onChanged: (patient) {
    print('Selected patient: ${patient?.name}');
  },
)
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

## 🌐 API & Remote Search

`SmartSearchDropdown` supports asynchronous data sources and backend API search queries out of the box using the `asyncSearch` callback.

This makes it ideal for real-world application use cases such as:
- Hospital search
- Facility search
- Doctor / provider search
- Patient search
- Department search
- City / country search
- Remote autocomplete inputs
- Server-side search queries
- API-powered dropdowns
- Asynchronous search operations

### Remote API Autocomplete Example

```dart
SmartSearchDropdown<Facility>(
  asyncSearch: (query) async {
    // Perform server-side search request
    final response = await http.get(
      Uri.parse('https://api.example.com/facilities?search=$query'),
    );
    return parseFacilities(response.body);
  },
  search: const SmartDropdownSearchConfig(
    hintText: 'Type to search remote facilities...',
    debounceDuration: Duration(milliseconds: 300),
  ),
  itemLabelBuilder: (facility) => facility.name,
  hintText: 'Search Facility',
  onChanged: (facility) {
    setState(() => selectedFacility = facility);
  },
)
```

When `asyncSearch` is provided, `SmartSearchDropdown` manages request debouncing (300ms default), triggers progress spinners, and displays error messages automatically if an exception occurs during the API call.

---

## 📄 Infinite Scroll & API Pagination

For applications dealing with large backend datasets, `SmartSearchDropdown` provides infinite scroll pagination using `SmartDropdownPaginationConfig`.

The package manages the scroll trigger and load-more lifecycle, while your application's API repository determines the page number and record size returned per request.

### Paginated Flow Overview

1. **Initial Load**: Popup opens showing Page 1 (e.g. 10 records).
2. **Scroll Trigger**: User scrolls near the bottom of the list.
3. **Load More Callback**: `onLoadMore` is invoked with `page: 2`.
4. **Appended Records**: The next 10 records are fetched and appended seamlessly to the list view.

### Paginated API Example

```dart
SmartSearchDropdown<Facility>(
  items: initialFacilitiesPage, // First 10 records
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  pagination: SmartDropdownPaginationConfig(
    enabled: true,
    pageSize: 10,
    scrollThreshold: 200.0,
    onLoadMore: (page) async {
      // Fetch Page N from backend repository (e.g., page 2 -> next 10 records)
      final List<Facility> nextPageItems = await apiRepository.getFacilities(
        page: page,
        pageSize: 10,
      );
      return nextPageItems;
    },
  ),
  hintText: 'Select Facility from large dataset',
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
