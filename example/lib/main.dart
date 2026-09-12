import 'package:flutter/material.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';
import 'models/facility.dart';

void main() {
  runApp(const SmartDropdownGalleryApp());
}

class SmartDropdownGalleryApp extends StatefulWidget {
  const SmartDropdownGalleryApp({super.key});

  @override
  State<SmartDropdownGalleryApp> createState() => _SmartDropdownGalleryAppState();
}

class _SmartDropdownGalleryAppState extends State<SmartDropdownGalleryApp> {
  Color _seedColor = Colors.teal;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartSearchDropdown Gallery',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: GalleryHomeScreen(
        currentSeedColor: _seedColor,
        currentThemeMode: _themeMode,
        onSeedColorChanged: (color) => setState(() => _seedColor = color),
        onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
      ),
    );
  }
}

class GalleryHomeScreen extends StatefulWidget {
  final Color currentSeedColor;
  final ThemeMode currentThemeMode;
  final ValueChanged<Color> onSeedColorChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const GalleryHomeScreen({
    super.key,
    required this.currentSeedColor,
    required this.currentThemeMode,
    required this.onSeedColorChanged,
    required this.onThemeModeChanged,
  });

  @override
  State<GalleryHomeScreen> createState() => _GalleryHomeScreenState();
}

class _GalleryHomeScreenState extends State<GalleryHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SmartSearchDropdown Gallery',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.currentThemeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            tooltip: 'Toggle Light/Dark Theme',
            onPressed: () {
              widget.onThemeModeChanged(
                widget.currentThemeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
          ),
          PopupMenuButton<Color>(
            icon: const Icon(Icons.palette_rounded),
            tooltip: 'Change Color Seed',
            onSelected: widget.onSeedColorChanged,
            itemBuilder: (context) => [
              _buildColorMenuItem(Colors.teal, 'Teal'),
              _buildColorMenuItem(Colors.blue, 'Blue'),
              _buildColorMenuItem(Colors.purple, 'Purple'),
              _buildColorMenuItem(Colors.green, 'Green'),
              _buildColorMenuItem(Colors.orange, 'Orange'),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view_rounded), text: '16 Variations Gallery'),
            Tab(icon: Icon(Icons.assignment_turned_in_rounded), text: 'Form Demo'),
            Tab(icon: Icon(Icons.gamepad_rounded), text: 'Controller Demo'),
            Tab(icon: Icon(Icons.cloud_download_rounded), text: 'Remote & Infinite Scroll'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const SixteenVariationsGalleryView(),
          const FormDemoView(),
          const ControllerDemoView(),
          const RemoteSearchDemoView(),
        ],
      ),
    );
  }

  PopupMenuItem<Color> _buildColorMenuItem(Color color, String name) {
    return PopupMenuItem(
      value: color,
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color, radius: 10),
          const SizedBox(width: 12),
          Text(name),
        ],
      ),
    );
  }
}

/// Grid View demonstrating all 16 Reference Designs from the specifications.
class SixteenVariationsGalleryView extends StatefulWidget {
  const SixteenVariationsGalleryView({super.key});

  @override
  State<SixteenVariationsGalleryView> createState() =>
      _SixteenVariationsGalleryViewState();
}

class _SixteenVariationsGalleryViewState
    extends State<SixteenVariationsGalleryView> {
  final facilities = Facility.mockFacilities;

  // Selected state per variation
  Facility? _selectedBasic;
  Facility? _selectedIcons;
  Facility? _selectedDesc;
  Facility? _selectedAvatar;
  Facility? _selectedGrouped;
  List<Facility> _selectedMulti = [];
  List<Facility> _selectedSelectAll = [];
  Facility? _selectedRecent;
  Facility? _selectedStatus;
  Facility? _selectedInfinite;
  final List<String> _dynamicItems = [
    'Sunshine Hospital',
    'Everest Hospital',
    'City Care Hospital'
  ];
  String? _selectedCreated;
  Facility? _selectedFiltered;
  Facility? _selectedRich;
  Facility? _selectedDark;
  Facility? _selectedEmpty;
  Facility? _selectedResponsive;

  String _typeFilter = 'All';
  final String _locationFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : (constraints.maxWidth > 800 ? 3 : (constraints.maxWidth > 500 ? 2 : 1));

        return GridView.count(
          crossAxisCount: crossAxisCount,
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.82,
          children: [
            // 1. Basic Searchable Dropdown
            _buildVariationCard(
              title: '1. Basic Searchable Dropdown',
              subtitle: 'Simple and clean design',
              child: SmartSearchDropdown<Facility>(
                items: facilities,
                value: _selectedBasic,
                itemLabelBuilder: (f) => f.name,
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedBasic = val),
              ),
            ),

            // 2. With Icons
            _buildVariationCard(
              title: '2. With Icons',
              subtitle: 'Shows icons with facility name',
              child: SmartSearchDropdown<Facility>(
                items: facilities,
                value: _selectedIcons,
                itemLabelBuilder: (f) => f.name,
                itemIconBuilder: (f) => Icon(f.icon),
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedIcons = val),
              ),
            ),

            // 3. With Descriptions
            _buildVariationCard(
              title: '3. With Descriptions',
              subtitle: 'Facility name with address/details',
              child: SmartSearchDropdown<Facility>(
                items: facilities,
                value: _selectedDesc,
                itemLabelBuilder: (f) => f.name,
                itemSubtitleBuilder: (f) => f.location,
                itemIconBuilder: (f) => Icon(f.icon),
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedDesc = val),
              ),
            ),

            // 4. With Logos / Avatars
            _buildVariationCard(
              title: '4. With Logos / Avatars',
              subtitle: 'Shows facility logo or avatar',
              child: SmartSearchDropdown<Facility>(
                items: facilities,
                value: _selectedAvatar,
                itemLabelBuilder: (f) => f.name,
                itemAvatarBuilder: (f) => CircleAvatar(
                  backgroundColor: f.avatarColor,
                  radius: 14,
                  child: Text(
                    f.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedAvatar = val),
              ),
            ),

            // 5. With Grouping
            _buildVariationCard(
              title: '5. With Grouping',
              subtitle: 'Categorized facilities',
              child: SmartSearchDropdown<Facility>(
                items: facilities,
                value: _selectedGrouped,
                itemLabelBuilder: (f) => f.name,
                itemIconBuilder: (f) => Icon(f.icon),
                groupBy: (f) => f.category,
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedGrouped = val),
              ),
            ),

            // 6. Multi-Select
            _buildVariationCard(
              title: '6. Multi-Select',
              subtitle: 'Select multiple facilities with chips',
              child: SmartSearchDropdown<Facility>.multi(
                items: facilities,
                selectedItems: _selectedMulti,
                itemLabelBuilder: (f) => f.name,
                hintText: 'Select Facilities',
                onMultiChanged: (vals) => setState(() => _selectedMulti = vals),
              ),
            ),

            // 7. Select All Option
            _buildVariationCard(
              title: '7. Select All / Clear All',
              subtitle: 'Quick select all / clear all header',
              child: SmartSearchDropdown<Facility>.multi(
                items: facilities,
                selectedItems: _selectedSelectAll,
                itemLabelBuilder: (f) => f.name,
                showSelectAll: true,
                showClearAll: true,
                hintText: 'Select Facility',
                onMultiChanged: (vals) => setState(() => _selectedSelectAll = vals),
              ),
            ),

            // 8. Recent / Popular
            _buildVariationCard(
              title: '8. Recent / Popular',
              subtitle: 'Shows recent or frequently used',
              child: SmartSearchDropdown<Facility>(
                items: facilities,
                value: _selectedRecent,
                itemLabelBuilder: (f) => f.name,
                recent: SmartDropdownRecentConfig(
                  enabled: true,
                  recentItems: facilities.where((f) => f.isRecent).toList(),
                  popularItems: facilities.where((f) => f.isPopular).toList(),
                ),
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedRecent = val),
              ),
            ),

            // 9. With Status / Tags
            _buildVariationCard(
              title: '9. With Status / Tags',
              subtitle: 'Shows status, type or tags',
              child: SmartSearchDropdown<Facility>(
                items: facilities,
                value: _selectedStatus,
                itemLabelBuilder: (f) => f.name,
                itemStatusBuilder: (f) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: f.statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    f.status,
                    style: TextStyle(
                      color: f.statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedStatus = val),
              ),
            ),

            // 10. Infinite Scroll / Load More
            _buildVariationCard(
              title: '10. Infinite Scroll / Load More',
              subtitle: 'For large datasets pagination',
              child: SmartSearchDropdown<Facility>(
                items: facilities.take(2).toList(),
                value: _selectedInfinite,
                itemLabelBuilder: (f) => f.name,
                pagination: SmartDropdownPaginationConfig(
                  enabled: true,
                  onLoadMore: (page) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return facilities.skip(2).toList();
                  },
                ),
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedInfinite = val),
              ),
            ),

            // 11. Create New Option
            _buildVariationCard(
              title: '11. Create New Option',
              subtitle: 'Add new facility directly',
              child: SmartSearchDropdown<String>(
                items: _dynamicItems,
                value: _selectedCreated,
                hintText: 'Type to create...',
                onCreateOption: (query) async {
                  setState(() {
                    _dynamicItems.add(query);
                    _selectedCreated = query;
                  });
                  return query;
                },
                onChanged: (val) => setState(() => _selectedCreated = val),
              ),
            ),

            // 12. Advanced Filter
            _buildVariationCard(
              title: '12. Advanced Filter',
              subtitle: 'Filter by type, location, etc.',
              child: SmartSearchDropdown<Facility>(
                items: facilities.where((f) {
                  final typeMatch = _typeFilter == 'All' || f.category == _typeFilter;
                  return typeMatch;
                }).toList(),
                value: _selectedFiltered,
                itemLabelBuilder: (f) => f.name,
                itemSubtitleBuilder: (f) => '${f.category} • ${f.location}',
                itemIconBuilder: (f) => Icon(f.icon),
                filters: SmartDropdownFilterConfig(
                  enabled: true,
                  builder: (context, controller) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              value: _typeFilter,
                              isExpanded: true,
                              isDense: true,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(value: 'All', child: Text('All Types')),
                                DropdownMenuItem(value: 'Multi-speciality', child: Text('Multi-speciality')),
                                DropdownMenuItem(value: 'General Hospital', child: Text('General Hospital')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _typeFilter = val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _locationFilter,
                              isExpanded: true,
                              isDense: true,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(value: 'All', child: Text('All Locations')),
                              ],
                              onChanged: (val) {},
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedFiltered = val),
              ),
            ),

            // 13. Rich Item Layout
            _buildVariationCard(
              title: '13. Rich Item Layout',
              subtitle: 'Custom design with ratings and tags',
              child: SmartSearchDropdown<Facility>(
                items: facilities,
                value: _selectedRich,
                itemLabelBuilder: (f) => f.name,
                itemBuilder: (context, f, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: f.avatarColor,
                          child: Icon(f.icon, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                                  Text(
                                    ' ${f.rating} (${f.reviewCount} reviews)',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(
                            f.isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                              color: f.isOpen ? Colors.green.shade800 : Colors.red.shade800,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: f.isOpen
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.red.withValues(alpha: 0.2),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  );
                },
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedRich = val),
              ),
            ),

            // 14. Dark Theme Card
            _buildVariationCard(
              title: '14. Dark Theme',
              subtitle: 'Isolated dark theme configuration',
              child: SmartSearchDropdownTheme(
                data: const SmartDropdownThemeData(
                  backgroundColor: Color(0xFF1E293B),
                  surfaceColor: Color(0xFF0F172A),
                  primaryColor: Colors.cyanAccent,
                  labelStyle: TextStyle(color: Colors.white),
                  subtitleStyle: TextStyle(color: Colors.white70),
                  hintStyle: TextStyle(color: Colors.white38),
                ),
                child: SmartSearchDropdown<Facility>(
                  items: facilities,
                  value: _selectedDark,
                  itemLabelBuilder: (f) => f.name,
                  itemIconBuilder: (f) => Icon(f.icon, color: Colors.cyanAccent),
                  hintText: 'Select Facility',
                  onChanged: (val) => setState(() => _selectedDark = val),
                ),
              ),
            ),

            // 15. Custom Empty State
            _buildVariationCard(
              title: '15. Custom Empty State',
              subtitle: 'Show meaningful graphics when empty',
              child: SmartSearchDropdown<Facility>(
                items: const [],
                value: _selectedEmpty,
                itemLabelBuilder: (f) => f.name,
                emptyBuilder: (context) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 40, color: Theme.of(context).primaryColor),
                        const SizedBox(height: 8),
                        const Text(
                          'No facilities found',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Try a different search term or clear filters.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                hintText: 'Select Facility',
                onChanged: (val) => setState(() => _selectedEmpty = val),
              ),
            ),

            // 16. Responsive Mobile View
            _buildVariationCard(
              title: '16. Responsive (Mobile View)',
              subtitle: 'Mobile-friendly full screen / BottomSheet',
              child: SmartSearchDropdown<Facility>(
                items: facilities,
                value: _selectedResponsive,
                itemLabelBuilder: (f) => f.name,
                popup: const SmartDropdownPopupConfig(
                  presentation: DropdownPresentation.bottomSheet,
                  mobileTitle: 'Select Facility',
                ),
                hintText: 'Tap to open BottomSheet',
                onChanged: (val) => setState(() => _selectedResponsive = val),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVariationCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            child,
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

/// Form Validation Demo
class FormDemoView extends StatefulWidget {
  const FormDemoView({super.key});

  @override
  State<FormDemoView> createState() => _FormDemoViewState();
}

class _FormDemoViewState extends State<FormDemoView> {
  final _formKey = GlobalKey<FormState>();
  Facility? _selectedFacility;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flutter Form Validation Integration',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'SmartSearchDropdownFormField seamlessly integrates with Flutter Form validation, autovalidateMode, and onSaved callbacks.',
            ),
            const SizedBox(height: 24),
            SmartSearchDropdownFormField<Facility>(
              items: Facility.mockFacilities,
              itemLabelBuilder: (f) => f.name,
              itemSubtitleBuilder: (f) => f.location,
              hintText: 'Select required facility',
              validator: (val) {
                if (val == null) {
                  return 'Please select a facility to proceed';
                }
                return null;
              },
              onChanged: (val) => setState(() => _selectedFacility = val),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('Validate & Submit Form'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Form Validated! Selected: ${_selectedFacility?.name}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Controller API Demo
class ControllerDemoView extends StatefulWidget {
  const ControllerDemoView({super.key});

  @override
  State<ControllerDemoView> createState() => _ControllerDemoViewState();
}

class _ControllerDemoViewState extends State<ControllerDemoView> {
  final SmartDropdownController<Facility> _controller = SmartDropdownController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Programmatic SmartDropdownController Demo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Programmatically open, close, select items, clear search, and listen to dropdown state.',
          ),
          const SizedBox(height: 24),
          SmartSearchDropdown<Facility>(
            controller: _controller,
            items: Facility.mockFacilities,
            itemLabelBuilder: (f) => f.name,
            itemSubtitleBuilder: (f) => f.location,
            hintText: 'Controlled Facility Dropdown',
            onChanged: (val) {},
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.unfold_more_rounded),
                label: const Text('Toggle Open/Close'),
                onPressed: () => _controller.toggle(),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.select_all_rounded),
                label: const Text('Programmatically Select #1'),
                onPressed: () => _controller.select(Facility.mockFacilities.first),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.clear_all_rounded),
                label: const Text('Clear All Selections'),
                onPressed: () => _controller.clearAll(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Remote API Search & Infinite Scroll Demo
class RemoteSearchDemoView extends StatefulWidget {
  const RemoteSearchDemoView({super.key});

  @override
  State<RemoteSearchDemoView> createState() => _RemoteSearchDemoViewState();
}

class _RemoteSearchDemoViewState extends State<RemoteSearchDemoView> {
  Facility? _selectedRemote;

  // Mock API search function
  Future<List<Facility>> _mockApiSearch(String query) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate API network latency
    if (query.isEmpty) {
      return Facility.mockFacilities;
    }
    return Facility.mockFacilities
        .where((f) => f.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remote API Search & Debouncing Demo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Demonstrates 300ms debounced async search with progress indicators and error handling.',
          ),
          const SizedBox(height: 24),
          SmartSearchDropdown<Facility>(
            asyncSearch: _mockApiSearch,
            value: _selectedRemote,
            itemLabelBuilder: (f) => f.name,
            itemSubtitleBuilder: (f) => f.location,
            itemIconBuilder: (f) => Icon(f.icon),
            search: const SmartDropdownSearchConfig(
              hintText: 'Type query (searches via mock API)...',
              debounceDuration: Duration(milliseconds: 300),
            ),
            hintText: 'Search remote API facilities',
            onChanged: (val) => setState(() => _selectedRemote = val),
          ),
        ],
      ),
    );
  }
}
