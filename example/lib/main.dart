import 'package:flutter/material.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';

import 'models/country.dart';
import 'models/framework.dart';
import 'models/product.dart';
import 'models/user_model.dart';

void main() {
  runApp(const SmartDropdownDemoApp());
}

class SmartDropdownDemoApp extends StatelessWidget {
  const SmartDropdownDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Search Dropdown Pro - Global Developer Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo primary
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const GlobalDeveloperPlayground(),
    );
  }
}

class GlobalDeveloperPlayground extends StatefulWidget {
  const GlobalDeveloperPlayground({super.key});

  @override
  State<GlobalDeveloperPlayground> createState() =>
      _GlobalDeveloperPlaygroundState();
}

class _GlobalDeveloperPlaygroundState extends State<GlobalDeveloperPlayground>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State variables for various demos
  Product? _selectedProduct;
  Country? _selectedCountry;
  List<Country> _selectedCountries = [];
  Framework? _selectedFramework;
  UserModel? _selectedUser;

  final SmartDropdownController<Product> _demoController =
      SmartDropdownController<Product>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart Search Dropdown Pro',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Global Developer Playground (v1.0.9)',
                style: TextStyle(fontSize: 12)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.flash_on), text: 'Simple API (L1)'),
            Tab(icon: Icon(Icons.settings), text: 'Advanced Config (L2)'),
            Tab(icon: Icon(Icons.checklist), text: 'Multi-Select & Chips'),
            Tab(icon: Icon(Icons.cloud_download), text: 'Async API Search'),
            Tab(icon: Icon(Icons.all_inclusive), text: 'Infinite Scroll'),
            Tab(icon: Icon(Icons.folder_special), text: 'Grouping'),
            Tab(icon: Icon(Icons.build), text: 'Custom Builders'),
            Tab(icon: Icon(Icons.text_fields), text: 'FormField Native'),
            Tab(icon: Icon(Icons.block), text: 'Disabled Items'),
            Tab(icon: Icon(Icons.stars), text: 'Controller Control'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSimpleApiTab(theme),
          _buildAdvancedConfigTab(theme),
          _buildMultiSelectTab(theme),
          _buildAsyncSearchTab(theme),
          _buildInfiniteScrollTab(theme),
          _buildGroupingTab(theme),
          _buildCustomBuildersTab(theme),
          _buildFormFieldTab(theme),
          _buildDisabledItemsTab(theme),
          _buildControllerTab(theme),
        ],
      ),
    );
  }

  // 1. Level 1 Simple API Demo
  Widget _buildSimpleApiTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Level 1 Simple API (Boolean Flags)'),
          const Text(
              'Direct top-level properties for clean, readable component setup.'),
          const SizedBox(height: 24),
          SmartSearchDropdown<Product>(
            labelText: 'Product Catalog *',
            hintText: 'Search electronics, audio, monitors...',
            items: sampleProducts,
            value: _selectedProduct,
            onChanged: (val) => setState(() => _selectedProduct = val),
            itemLabelBuilder: (p) => p.title,
            itemSubtitleBuilder: (p) =>
                '${p.category} • \$${p.price.toStringAsFixed(2)}',
            itemIconBuilder: (p) => const Icon(Icons.shopping_bag_outlined),
            showSearch: true,
            showClearButton: true,
            showDropdownIcon: true,
          ),
          const SizedBox(height: 16),
          if (_selectedProduct != null)
            Card(
              child: ListTile(
                title: Text('Selected: ${_selectedProduct!.title}'),
                subtitle: Text(
                    'Category: ${_selectedProduct!.category} • Price: \$${_selectedProduct!.price}'),
              ),
            ),
        ],
      ),
    );
  }

  // 2. Level 2 Advanced Config API Demo
  Widget _buildAdvancedConfigTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Level 2 Advanced Configuration Objects'),
          const Text(
              'Granular control over search debounce, popup elevation, and selection rules.'),
          const SizedBox(height: 24),
          SmartSearchDropdown<Country>(
            labelText: 'Select Target Country',
            hintText: 'Choose market country...',
            items: sampleCountries,
            value: _selectedCountry,
            onChanged: (val) => setState(() => _selectedCountry = val),
            itemLabelBuilder: (c) => '${c.flag} ${c.name}',
            itemSubtitleBuilder: (c) => 'Region: ${c.region}',
            config: SmartDropdownConfig<Country>(
              search: const SmartDropdownSearchConfig(
                enabled: true,
                hintText: 'Filter countries...',
                highlightMatches: true,
                debounceDuration: Duration(milliseconds: 150),
              ),
              popup: SmartDropdownPopupConfig(
                maxHeight: 280,
                elevation: 8.0,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Multi-Select & Chips Demo
  Widget _buildMultiSelectTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Multi-Select & Custom Chip Display'),
          const Text(
              'Select multiple items with Select All, Clear All, and dismissible chips.'),
          const SizedBox(height: 24),
          SmartSearchDropdown<Country>.multi(
            labelText: 'Operating Regions',
            hintText: 'Select one or more countries',
            items: sampleCountries,
            selectedItems: _selectedCountries,
            onMultiChanged: (vals) => setState(() => _selectedCountries = vals),
            itemLabelBuilder: (c) => '${c.flag} ${c.name}',
            showSelectAll: true,
            showClearAll: true,
            showCheckbox: true,
          ),
        ],
      ),
    );
  }

  // 4. Async API Search Demo
  Widget _buildAsyncSearchTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Async Remote API Search'),
          const Text(
              'Simulates remote backend API queries with race condition protection.'),
          const SizedBox(height: 24),
          SmartSearchDropdown<Framework>(
            labelText: 'Tech Stack Framework',
            hintText: 'Search tech stack (e.g. Flutter, React, Spring)',
            value: _selectedFramework,
            asyncSearch: (query) async {
              await Future.delayed(const Duration(milliseconds: 400));
              if (query.isEmpty) return sampleFrameworks;
              return sampleFrameworks
                  .where((f) =>
                      f.name.toLowerCase().contains(query.toLowerCase()) ||
                      f.language.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            },
            itemLabelBuilder: (f) => f.name,
            itemSubtitleBuilder: (f) => 'Language: ${f.language}',
            itemIconBuilder: (f) => const Icon(Icons.code_rounded),
            onChanged: (f) => setState(() => _selectedFramework = f),
          ),
        ],
      ),
    );
  }

  // 5. Infinite Scroll Pagination Demo
  Widget _buildInfiniteScrollTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Infinite Scroll Pagination'),
          const Text(
              'Automatically fetches next pages as user scrolls down the list.'),
          const SizedBox(height: 24),
          SmartSearchDropdown<Product>(
            labelText: 'Paginated Product Inventory',
            hintText: 'Scroll down to load next page...',
            loader: (query, page) async {
              await Future.delayed(const Duration(milliseconds: 500));
              final start = (page - 1) * 4;
              if (start >= sampleProducts.length) {
                return DropdownPageResult(items: [], hasMore: false);
              }
              final end = (start + 4) < sampleProducts.length
                  ? start + 4
                  : sampleProducts.length;
              final pageItems = sampleProducts.sublist(start, end);
              return DropdownPageResult(
                  items: pageItems, hasMore: end < sampleProducts.length);
            },
            itemLabelBuilder: (p) => p.title,
            itemSubtitleBuilder: (p) => '\$${p.price}',
            pageSize: 4,
            onChanged: (p) {},
          ),
        ],
      ),
    );
  }

  // 6. Grouping Demo
  Widget _buildGroupingTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Grouped Items by Category'),
          const Text('Organizes items into categorical headers naturally.'),
          const SizedBox(height: 24),
          SmartSearchDropdown<Product>(
            labelText: 'Categorized Products',
            hintText: 'Browse by category',
            items: sampleProducts,
            groupBy: (p) => p.category,
            enableGrouping: true,
            itemLabelBuilder: (p) => p.title,
            onChanged: (p) {},
          ),
        ],
      ),
    );
  }

  // 7. Custom Builders Demo
  Widget _buildCustomBuildersTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Custom Search Field & Tile Builders'),
          const Text(
              'Custom search field UI, leading avatars, and status badges.'),
          const SizedBox(height: 24),
          SmartSearchDropdown<UserModel>(
            labelText: 'Team Member Assignment',
            hintText: 'Select team member',
            items: sampleUsers,
            value: _selectedUser,
            onChanged: (u) => setState(() => _selectedUser = u),
            itemLabelBuilder: (u) => u.name,
            itemSubtitleBuilder: (u) => u.role,
            itemAvatarBuilder: (u) => CircleAvatar(
              radius: 16,
              child: Text(u.name.substring(0, 1)),
            ),
            itemStatusBuilder: (u) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Active',
                  style: TextStyle(color: Colors.green, fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  // 8. Native FormField Demo
  Widget _buildFormFieldTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Flutter Form Integration & Validation'),
            const Text(
                'Integrates seamlessly with FormState and autovalidateMode.'),
            const SizedBox(height: 24),
            SmartSearchDropdownFormField<Country>(
              labelText: 'Shipping Country *',
              hintText: 'Select country',
              items: sampleCountries,
              itemLabelBuilder: (c) => '${c.flag} ${c.name}',
              validator: (val) {
                if (val == null) return 'Please select a shipping country';
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Form validated successfully!')),
                  );
                }
              },
              child: const Text('Submit Form'),
            ),
          ],
        ),
      ),
    );
  }

  // 9. Disabled Items Demo
  Widget _buildDisabledItemsTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Item-Level Disabled State'),
          const Text(
              'Disable specific items based on business logic (e.g. out of stock products).'),
          const SizedBox(height: 24),
          SmartSearchDropdown<Product>(
            labelText: 'Product Availability',
            hintText: 'Select in-stock product',
            items: sampleProducts,
            isItemDisabled: (p) =>
                p.price > 1000.0, // Disable items > $1000 for demo
            itemLabelBuilder: (p) => p.title,
            itemSubtitleBuilder: (p) => p.price > 1000.0
                ? '\$${p.price} (Out of budget)'
                : '\$${p.price}',
            onChanged: (p) {},
          ),
        ],
      ),
    );
  }

  // 10. Controller Demo
  Widget _buildControllerTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Programmatic SmartDropdownController'),
          const Text(
              'Control open/close state, search queries, and selections programmatically.'),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _demoController.open(),
                child: const Text('Open Dropdown'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _demoController.close(),
                child: const Text('Close Dropdown'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => _demoController.clear(),
                child: const Text('Clear Selection'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SmartSearchDropdown<Product>(
            controller: _demoController,
            labelText: 'Controller-Managed Dropdown',
            hintText: 'Controlled via external controller',
            items: sampleProducts,
            itemLabelBuilder: (p) => p.title,
            onChanged: (p) {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
