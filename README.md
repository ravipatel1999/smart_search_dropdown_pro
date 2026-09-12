# SmartSearchDropdown Pro

A production-ready, type-safe, highly customizable, and searchable Flutter dropdown package. Designed to provide **ONE unified widget API** for over 16+ dropdown UI experiences—ranging from simple selectors to multi-select chips, grouped lists, remote API searching with debouncing, infinite scroll pagination, tags, recent items, and dark mode theme adaptation.

[![Pub Version](https://img.shields.io/pub/v/smart_search_dropdown_pro.svg)](https://pub.dev/packages/smart_search_dropdown_pro)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue)](https://flutter.dev)

---

## 📸 Visual Showcase & Assets

`SmartSearchDropdown` comes with rich UI capabilities out of the box. Below is the visual preview showcasing various presentation modes and design variations.

<p align="center">
  <img
    src="assets/smart_search_dropdown_pro_showcase.png"
    alt="SmartSearchDropdown Pro Showcase"
    width="100%"
  />
</p>

> **Asset Path:** `assets/smart_search_dropdown_pro_showcase.png`

> Includes variations for single select, multi-select chips, grouped options, custom avatars, status badges, adaptive bottom sheets, and dark mode.
---

## 💡 About This Package

`smart_search_dropdown_pro` was created to solve the fragmentation in Flutter dropdown implementations. Instead of bringing in separate packages for multi-select chips, search filtering, remote API calls, or mobile bottom sheets, `SmartSearchDropdown` unifies all of them into a single, cohesive, performant component.

### Key Highlights

- 🎯 **Single & Multi-Select Modes**: Seamless toggle between single-item selection and multi-select chip tags with Select All / Clear All support.
- ⚡ **Type-Safe Generic (`<T>`)**: Works natively with `String`, `int`, `enum`, or custom Dart models (`User`, `Facility`, `Product`, etc.).
- 🔍 **Flexible Search Strategies**: Instant local search matching with support for `contains`, `startsWith`, `fuzzy`, and `custom` search functions.
- 🌐 **Remote API & Async Search**: Built-in debouncing, loading states, error handling, infinite scroll pagination, and load-more callbacks.
- 📱 **Adaptive Responsive Presentation**: Automatically switches between anchored overlay popups on Desktop/Web/Tablet and BottomSheet/Modal Dialog on Mobile devices (<600px width).
- 📝 **Flutter Form Field Integration**: Built-in `SmartSearchDropdownFormField<T>` for seamless integration with Flutter `Form`, validation rules, and `autovalidateMode`.
- 🎮 **Programmatic Controller**: Full control via `SmartDropdownController<T>` to open, close, toggle, select, deselect, clear, or update state programmatically.
- 🎨 **Material 3 & Dark Theme Ready**: Automatically inherits colors, typography, and border radius from Flutter `Theme.of(context)`, with full override options via `SmartDropdownThemeData`.
- ♿ **Keyboard & Accessibility Support**: Keyboard navigation, focus nodes, tab traversal, and semantics support.

---

## 📦 Installation

Add `smart_search_dropdown_pro` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_search_dropdown_pro: ^1.0.2
```

Include the assets in your `pubspec.yaml` if you want to use package showcase graphics or bundled assets:

```yaml
flutter:
  assets:
    - assets/smart_search_dropdown_pro_showcase.png
```

Import the library in your Dart file:

```dart
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';
```

---

## 🚀 Quick Start

Here is the minimal code needed to render a type-safe searchable dropdown:

```dart
import 'package:flutter/material.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';

class QuickStartExample extends StatefulWidget {
  const QuickStartExample({super.key});

  @override
  State<QuickStartExample> createState() => _QuickStartExampleState();
}

class _QuickStartExampleState extends State<QuickStartExample> {
  String? selectedFacility;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartSearchDropdown Quick Start')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SmartSearchDropdown<String>(
          items: const [
            'Sunshine Hospital',
            'Everest Hospital',
            'City Care Hospital',
            'Metro Health Clinic',
          ],
          value: selectedFacility,
          hintText: 'Select Facility',
          onChanged: (value) {
            setState(() {
              selectedFacility = value;
            });
          },
        ),
      ),
    );
  }
}
```

---

## 🎨 16 UI Variations & Code Examples

Every variation below uses the same flexible `SmartSearchDropdown<T>` API with configuration objects.

### 1. Basic Searchable Dropdown
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 2. Searchable Dropdown with Icons
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  itemIconBuilder: (f) => Icon(f.icon),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 3. Searchable Dropdown with Subtitles
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  itemSubtitleBuilder: (f) => '${f.category} • ${f.location}',
  itemIconBuilder: (f) => Icon(f.icon),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 4. Searchable Dropdown with Avatars
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  itemAvatarBuilder: (f) => CircleAvatar(
    backgroundColor: f.color,
    radius: 14,
    child: Text(f.name[0]),
  ),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 5. Grouped Items Dropdown
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  groupBy: (f) => f.category,
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 6. Multi-Select Dropdown with Chips
```dart
SmartSearchDropdown<Facility>.multi(
  items: facilities,
  selectedItems: selectedFacilities,
  itemLabelBuilder: (f) => f.name,
  hintText: 'Select Facilities',
  onMultiChanged: (list) => setState(() => selectedFacilities = list),
)
```

### 7. Select All & Clear All Controls
```dart
SmartSearchDropdown<Facility>.multi(
  items: facilities,
  selectedItems: selectedFacilities,
  itemLabelBuilder: (f) => f.name,
  showSelectAll: true,
  showClearAll: true,
  hintText: 'Select Facilities',
  onMultiChanged: (list) => setState(() => selectedFacilities = list),
)
```

### 8. Recent & Popular Items
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  recent: SmartDropdownRecentConfig(
    enabled: true,
    recentItems: recentFacilities,
    popularItems: popularFacilities,
  ),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 9. Custom Status Badges & Tags
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  itemStatusBuilder: (f) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: f.statusColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      f.status,
      style: TextStyle(color: f.statusColor, fontWeight: FontWeight.bold, fontSize: 11),
    ),
  ),
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 10. Infinite Scroll & Lazy Loading
```dart
SmartSearchDropdown<Facility>(
  items: initialFacilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  pagination: SmartDropdownPaginationConfig(
    enabled: true,
    onLoadMore: (page) async {
      return await apiRepository.fetchFacilities(page: page);
    },
  ),
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 11. Create New Option On-the-Fly
```dart
SmartSearchDropdown<String>(
  items: facilityNames,
  value: selectedName,
  hintText: 'Type to search or create...',
  onCreateOption: (query) async {
    final newName = await apiRepository.createNewFacility(query);
    setState(() {
      facilityNames.add(newName);
      selectedName = newName;
    });
    return newName;
  },
  onChanged: (name) => setState(() => selectedName = name),
)
```

### 12. Custom Header Filters
```dart
SmartSearchDropdown<Facility>(
  items: filteredFacilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  filters: SmartDropdownFilterConfig(
    enabled: true,
    builder: (context, controller) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          value: activeCategoryFilter,
          isExpanded: true,
          items: categoryOptions,
          onChanged: (category) {
            setState(() => activeCategoryFilter = category!);
          },
        ),
      );
    },
  ),
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 13. Custom Item Builder (Rich Custom UI)
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  itemBuilder: (context, facility, state) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: state.isSelected ? Colors.blue.withOpacity(0.1) : null,
      child: Row(
        children: [
          Icon(facility.icon, color: state.isSelected ? Colors.blue : Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(facility.name, style: TextStyle(fontWeight: state.isSelected ? FontWeight.bold : FontWeight.normal))),
          if (state.isSelected) const Icon(Icons.check_circle, color: Colors.blue),
        ],
      ),
    );
  },
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 14. Theme Customization & Dark Mode
```dart
SmartSearchDropdownTheme(
  data: SmartDropdownThemeData(
    primaryColor: Colors.teal,
    surfaceColor: const Color(0xFF1E293B),
    borderRadius: BorderRadius.circular(16),
  ),
  child: SmartSearchDropdown<Facility>(
    items: facilities,
    itemLabelBuilder: (f) => f.name,
    onChanged: (f) {},
  ),
)
```

### 15. Custom Empty Builder
```dart
SmartSearchDropdown<Facility>(
  items: const [],
  emptyBuilder: (context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text('No matching facilities found', style: TextStyle(color: Colors.grey)),
        ],
      ),
    ),
  ),
  onChanged: (f) {},
)
```

### 16. Adaptive Mobile BottomSheet Presentation
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (f) => f.name,
  popup: const SmartDropdownPopupConfig(
    presentation: DropdownPresentation.adaptive, // Uses BottomSheet on mobile (<600px width)
    mobileTitle: 'Choose Facility',
  ),
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

---

## 📝 Form Validation Integration

Use `SmartSearchDropdownFormField<T>` inside Flutter `Form` widgets for out-of-the-box validation:

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      SmartSearchDropdownFormField<Facility>(
        items: facilities,
        itemLabelBuilder: (f) => f.name,
        hintText: 'Select required facility',
        validator: (val) {
          if (val == null) return 'Please select a facility';
          return null;
        },
        onSaved: (val) => savedFacility = val,
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
          }
        },
        child: const Text('Submit'),
      ),
    ],
  ),
)
```

---

## 🌐 Remote API Async Search

Pass an `asyncSearch` callback to automatically query remote REST or GraphQL APIs with debouncing:

```dart
SmartSearchDropdown<Facility>(
  asyncSearch: (query) async {
    final response = await http.get(Uri.parse('https://api.example.com/facilities?q=$query'));
    return parseFacilities(response.body);
  },
  search: const SmartDropdownSearchConfig(
    hintText: 'Search remote API...',
    debounceDuration: Duration(milliseconds: 300),
  ),
  hintText: 'Search facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

---

## 🎮 Programmatic Controller API

Use `SmartDropdownController<T>` to programmatically manage state:

```dart
final controller = SmartDropdownController<Facility>();

// Open dropdown popup
controller.open();

// Close dropdown popup
controller.close();

// Toggle open/close
controller.toggle();

// Programmatically select item
controller.select(facility);

// Deselect item
controller.deselect(facility);

// Select all items
controller.selectAll(facilities);

// Clear all selections
controller.clearAll();

// Update search query programmatically
controller.setSearchQuery('Everest');
```

---

## ⚙️ Configuration Reference

| Config Object | Key Properties | Description |
|---|---|---|
| `SmartDropdownSearchConfig` | `enabled`, `hintText`, `autoFocus`, `debounceDuration`, `searchMode`, `minChars`, `highlightMatches`, `customSearch` | Controls search input behavior, debouncing, and matching logic. |
| `SmartDropdownSelectionConfig` | `mode`, `showSelectAll`, `showClearAll`, `selectAllText`, `clearAllText`, `maxSelections`, `minSelections`, `allowChipRemoval` | Controls single/multi-selection modes and chip display. |
| `SmartDropdownPopupConfig` | `presentation`, `maxHeight`, `width`, `elevation`, `mobileTitle`, `borderRadius`, `mobileBreakpoint`, `offset` | Configures popup overlay presentation, height, and responsiveness. |
| `SmartDropdownFilterConfig` | `enabled`, `builder` | Renders custom filter headers inside the dropdown popup. |
| `SmartDropdownPaginationConfig` | `enabled`, `scrollThreshold`, `onLoadMore`, `pageSize`, `loadingFooterBuilder` | Configures infinite scroll and paged remote API loading. |
| `SmartDropdownCreateOptionConfig` | `enabled`, `onCreate`, `createLabelBuilder`, `builder` | Configures creation of new options when search query matches no items. |
| `SmartDropdownRecentConfig` | `enabled`, `recentItems`, `popularItems`, `recentTitle`, `popularTitle`, `storage` | Displays recent and popular item sections inside the dropdown. |

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
