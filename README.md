# SmartSearchDropdownPro

A production-ready, type-safe, highly reusable, and searchable Flutter dropdown package for pub.dev.

Designed so Flutter developers can use **ONE unified widget API** to create over 16+ different searchable dropdown UI experiences—from simple string selectors to complex multi-selects with filters, remote API pagination, grouping, tags, recent items, and dark mode—without writing custom overlay logic.

---

## Key Features

- 🎯 **Single & Multi-Select**: Built-in support for single items or multiple chip selections.
- ⚡ **Type-Safe & Generic (`<T>`)**: Works directly with String, int, enum, or custom Dart model classes.
- 🔍 **Powerful Search**: Instant typing search, case-insensitive matching, starts-with, contains, fuzzy search, debounce, and match highlighting.
- 🌐 **Remote & Async Search**: Built-in loading states, debouncing, pagination, infinite scroll, and duplicate request protection.
- 🎨 **Automatic Theme Adaptation**: Inherits directly from Flutter `Theme.of(context)` (Light, Dark, Material 3, seed colors) with optional custom `SmartDropdownThemeData`.
- 📱 **Adaptive Responsive Layouts**: Automatically switches between anchored popup menu on Desktop/Web/Tablet and BottomSheet/Modal Dialog on Mobile (<600px width).
- 📝 **Flutter Form Field Integration**: `SmartSearchDropdownFormField<T>` with standard Flutter validation and autovalidateMode support.
- 🎮 **Programmatic Controller**: `SmartDropdownController<T>` to programmatically open, close, select, deselect, clear, or trigger loadMore.
- ♿ **Accessibility & Keyboard Navigation**: Full semantics, tab focus, arrow key navigation, Enter selection, and Escape to close.

---

## Installation

Add `smart_search_dropdown_pro` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_search_dropdown_pro: ^1.0.0
```

Import the library:

```dart
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';
```

---

## Quick Start (Simple API)

```dart
SmartSearchDropdown<String>(
  items: const [
    'Sunshine Hospital',
    'Everest Hospital',
    'City Care Hospital',
  ],
  hintText: 'Select Facility',
  onChanged: (selected) {
    print('Selected: $selected');
  },
)
```

---

## 16 Design Variations & Code Examples

Every variation below uses the same flexible `SmartSearchDropdown<T>` widget with simple configuration options.

### 1. Basic Searchable Dropdown
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
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  itemAvatarBuilder: (facility) => CircleAvatar(
    backgroundColor: facility.avatarColor,
    radius: 14,
    child: Text(facility.name[0]),
  ),
  hintText: 'Select Facility',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 5. Grouped Dropdown
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
```dart
SmartSearchDropdown<Facility>.multi(
  items: facilities,
  selectedItems: selectedFacilities,
  itemLabelBuilder: (facility) => facility.name,
  hintText: 'Select Facilities',
  onMultiChanged: (facilities) => setState(() => selectedFacilities = facilities),
)
```

### 7. Select All / Clear All Options
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

### 9. Status & Tags Badges
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  itemStatusBuilder: (facility) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: facility.statusColor.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      facility.status,
      style: TextStyle(color: facility.statusColor, fontWeight: FontWeight.bold),
    ),
  ),
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 10. Infinite Scroll / Load More
```dart
SmartSearchDropdown<Facility>(
  items: pagedFacilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  pagination: SmartDropdownPaginationConfig(
    enabled: true,
    onLoadMore: (page) async {
      return await api.getFacilitiesPage(page);
    },
  ),
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 11. Create New Option On-the-Fly
```dart
SmartSearchDropdown<String>(
  items: existingFacilityNames,
  value: selectedFacilityName,
  hintText: 'Type to search or create...',
  onCreateOption: (query) async {
    final created = await api.createFacility(query);
    setState(() => existingFacilityNames.add(created));
    return created;
  },
  onChanged: (name) => setState(() => selectedFacilityName = name),
)
```

### 12. Advanced Header Filter Dropdown
```dart
SmartSearchDropdown<Facility>(
  items: filteredFacilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  filters: SmartDropdownFilterConfig(
    enabled: true,
    builder: (context, controller) {
      return Row(
        children: [
          DropdownButton<String>(
            value: selectedCategory,
            items: categoryMenuItems,
            onChanged: (cat) => setState(() => selectedCategory = cat),
          ),
        ],
      );
    },
  ),
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 13. Rich Item Layout
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  value: selectedFacility,
  itemLabelBuilder: (facility) => facility.name,
  itemBuilder: (context, facility, state) {
    return ListTile(
      leading: Image.network(facility.imageUrl),
      title: Text(facility.name),
      subtitle: Text('⭐ ${facility.rating} (${facility.reviews} reviews)'),
      trailing: Text(facility.isOpen ? 'Open' : 'Closed'),
    );
  },
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

### 14. Dark Theme
`SmartSearchDropdown` automatically inherits dark colors from `Theme.of(context)` when `ThemeData.dark()` is active. You can also customize package styles using `SmartSearchDropdownTheme`:

```dart
SmartSearchDropdownTheme(
  data: const SmartDropdownThemeData(
    backgroundColor: Color(0xFF1E293B),
    surfaceColor: Color(0xFF0F172A),
    primaryColor: Colors.cyanAccent,
  ),
  child: SmartSearchDropdown<Facility>(
    items: facilities,
    onChanged: (val) {},
  ),
)
```

### 15. Custom Empty State
```dart
SmartSearchDropdown<Facility>(
  items: const [],
  emptyBuilder: (context) => const Center(
    child: Column(
      children: [
        Icon(Icons.search_off_rounded, size: 48),
        Text('No facilities found'),
      ],
    ),
  ),
  onChanged: (val) {},
)
```

### 16. Responsive Mobile Presentation
```dart
SmartSearchDropdown<Facility>(
  items: facilities,
  popup: const SmartDropdownPopupConfig(
    presentation: DropdownPresentation.adaptive, // Automatically uses BottomSheet on mobile
    mobileTitle: 'Select Facility',
  ),
  onChanged: (val) {},
)
```

---

## Flutter Form Integration

Use `SmartSearchDropdownFormField<T>` to easily add form validation:

```dart
SmartSearchDropdownFormField<Facility>(
  items: facilities,
  itemLabelBuilder: (facility) => facility.name,
  validator: (val) {
    if (val == null) return 'Please select a facility';
    return null;
  },
  onSaved: (val) => savedFacility = val,
)
```

---

## Remote API Search Example

```dart
SmartSearchDropdown<Facility>(
  asyncSearch: (query) async {
    return await repository.searchFacilities(query);
  },
  search: const SmartDropdownSearchConfig(
    debounceDuration: Duration(milliseconds: 300),
  ),
  hintText: 'Search remote API...',
  onChanged: (facility) => setState(() => selectedFacility = facility),
)
```

---

## Controller Usage

```dart
final controller = SmartDropdownController<Facility>();

// Open popup
controller.open();

// Close popup
controller.close();

// Programmatically select
controller.select(facility);

// Clear selection
controller.clearAll();
```

---

## License

MIT License.
