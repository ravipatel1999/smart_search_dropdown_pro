import 'dart:async';
import 'package:flutter/material.dart';
import '../config/smart_dropdown_config.dart';
import '../config/smart_dropdown_create_option_config.dart';
import '../config/smart_dropdown_filter_config.dart';
import '../config/smart_dropdown_pagination_config.dart';
import '../config/smart_dropdown_popup_config.dart';
import '../config/smart_dropdown_recent_config.dart';
import '../config/smart_dropdown_search_config.dart';
import '../config/smart_dropdown_selection_config.dart';
import '../controllers/smart_dropdown_controller.dart';
import '../enums/dropdown_presentation.dart';
import '../enums/selection_mode.dart';
import '../models/dropdown_group.dart';
import '../models/dropdown_item_state.dart';
import '../models/recent_popular_item.dart';
import '../utilities/dropdown_position.dart';
import '../utilities/search_utils.dart';
import 'smart_dropdown_popup.dart';
import 'smart_dropdown_trigger.dart';

/// Result model returned by paged loader functions.
class DropdownPageResult<T> {
  final List<T> items;
  final bool hasMore;

  DropdownPageResult({required this.items, required this.hasMore});
}

/// Signature for paged data loader callback.
typedef DropdownLoader<T> = Future<DropdownPageResult<T>> Function(String query, int page);

/// Modern, highly reusable, type-safe searchable dropdown system for Flutter.
class SmartSearchDropdown<T> extends StatefulWidget {
  /// Master list of items.
  final List<T>? items;

  /// Currently selected item in single selection mode.
  final T? value;

  /// Currently selected items in multi-selection mode.
  final List<T>? selectedItems;

  /// Callback fired when single selection changes.
  final ValueChanged<T?>? onChanged;

  /// Callback fired when multi-selection changes.
  final ValueChanged<List<T>>? onMultiChanged;

  /// Async search callback for remote API queries.
  final Future<List<T>> Function(String query)? asyncSearch;

  /// Label builder extracting string label from item [T].
  final String Function(T item)? itemLabelBuilder;

  /// Subtitle / description builder.
  final String? Function(T item)? itemSubtitleBuilder;

  /// Leading icon builder.
  final Widget? Function(T item)? itemIconBuilder;

  /// Leading logo / avatar builder.
  final Widget? Function(T item)? itemAvatarBuilder;

  /// Trailing status badge builder.
  final Widget? Function(T item)? itemStatusBuilder;

  /// Custom trailing builder.
  final Widget? Function(T item)? itemTrailingBuilder;

  /// Group category extractor function.
  final String Function(T item)? groupBy;

  /// Group header UI builder.
  final Widget Function(BuildContext context, String groupName)? groupHeaderBuilder;

  /// Item tile custom builder.
  final Widget Function(BuildContext context, T item, SmartDropdownItemState state)? itemBuilder;

  /// Trigger field custom display when item selected.
  final Widget Function(BuildContext context, T item)? selectedItemBuilder;

  /// Custom empty state builder when no items match.
  final WidgetBuilder? emptyBuilder;

  /// Custom error builder.
  final Widget Function(BuildContext context, String error)? errorBuilder;

  /// Custom loading builder.
  final WidgetBuilder? loadingBuilder;

  /// Callback executed when user selects create option.
  final Future<T?> Function(String query)? onCreateOption;

  /// Master configuration object.
  final SmartDropdownConfig<T>? config;

  /// Shortcut search config override.
  final SmartDropdownSearchConfig? search;

  /// Shortcut selection config override.
  final SmartDropdownSelectionConfig? selection;

  /// Shortcut popup config override.
  final SmartDropdownPopupConfig? popup;

  /// Shortcut filter config override.
  final SmartDropdownFilterConfig<T>? filters;

  /// Shortcut pagination config override.
  final SmartDropdownPaginationConfig<T>? pagination;

  /// Shortcut create option config override.
  final SmartDropdownCreateOptionConfig<T>? createOption;

  /// Shortcut recent/popular config override.
  final SmartDropdownRecentConfig<T>? recent;

  /// Optional external controller instance.
  final SmartDropdownController<T>? controller;

  /// Placeholder text in trigger box.
  final String hintText;

  /// Whether dropdown is interactable.
  final bool enabled;

  /// Validation error text string.
  final String? errorText;

  /// Item-level enablement callback.
  final bool Function(T item)? isItemEnabled;

  /// Top field label (e.g. "Facility Type *" where trailing '*' is rendered in red).
  final String? labelText;

  /// Leading icon inside the trigger box.
  final Widget? prefixIcon;

  /// Optional widget displayed on the right of the top label (e.g. '+' button).
  final Widget? trailingLabelWidget;

  /// Shortcut for popup search box placeholder.
  final String? searchHint;

  /// Whether to show the clear button when item is selected.
  final bool? showClearButton;

  /// Max height for the dropdown popup panel.
  final double? maxPanelHeight;

  /// Convenience paged loader function.
  final Future<DropdownPageResult<T>> Function(String query, int page)? loader;

  /// Shortcut for search debounce duration in milliseconds.
  final int? debounceMs;

  /// Shortcut for page size.
  final int? pageSize;

  const SmartSearchDropdown({
    super.key,
    this.items,
    this.value,
    this.selectedItems,
    this.onChanged,
    this.onMultiChanged,
    this.asyncSearch,
    this.itemLabelBuilder,
    this.itemSubtitleBuilder,
    this.itemIconBuilder,
    this.itemAvatarBuilder,
    this.itemStatusBuilder,
    this.itemTrailingBuilder,
    this.groupBy,
    this.groupHeaderBuilder,
    this.itemBuilder,
    this.selectedItemBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.onCreateOption,
    this.config,
    this.search,
    this.selection,
    this.popup,
    this.filters,
    this.pagination,
    this.createOption,
    this.recent,
    this.controller,
    this.hintText = 'Select Option',
    this.enabled = true,
    this.errorText,
    this.isItemEnabled,
    this.labelText,
    this.prefixIcon,
    this.trailingLabelWidget,
    this.searchHint,
    this.showClearButton,
    this.maxPanelHeight,
    this.loader,
    this.debounceMs,
    this.pageSize,
  });

  /// Convenient named constructor for multi-selection mode.
  factory SmartSearchDropdown.multi({
    Key? key,
    List<T>? items,
    List<T>? selectedItems,
    required ValueChanged<List<T>> onMultiChanged,
    Future<List<T>> Function(String query)? asyncSearch,
    String Function(T item)? itemLabelBuilder,
    String? Function(T item)? itemSubtitleBuilder,
    Widget? Function(T item)? itemIconBuilder,
    Widget? Function(T item)? itemAvatarBuilder,
    Widget? Function(T item)? itemStatusBuilder,
    Widget? Function(T item)? itemTrailingBuilder,
    String Function(T item)? groupBy,
    Widget Function(BuildContext context, String groupName)? groupHeaderBuilder,
    Widget Function(BuildContext context, T item, SmartDropdownItemState state)? itemBuilder,
    WidgetBuilder? emptyBuilder,
    Widget Function(BuildContext context, String error)? errorBuilder,
    WidgetBuilder? loadingBuilder,
    SmartDropdownConfig<T>? config,
    SmartDropdownSearchConfig? search,
    SmartDropdownPopupConfig? popup,
    SmartDropdownFilterConfig<T>? filters,
    SmartDropdownPaginationConfig<T>? pagination,
    SmartDropdownController<T>? controller,
    String hintText = 'Select Options',
    bool enabled = true,
    String? errorText,
    bool showSelectAll = true,
    bool showClearAll = true,
    SmartDropdownSelectionConfig? selection,
    String? labelText,
    Widget? prefixIcon,
    Widget? trailingLabelWidget,
    String? searchHint,
    bool? showClearButton,
    double? maxPanelHeight,
    Future<DropdownPageResult<T>> Function(String query, int page)? loader,
    int? debounceMs,
    int? pageSize,
  }) {
    return SmartSearchDropdown<T>(
      key: key,
      items: items,
      selectedItems: selectedItems,
      onMultiChanged: onMultiChanged,
      asyncSearch: asyncSearch,
      itemLabelBuilder: itemLabelBuilder,
      itemSubtitleBuilder: itemSubtitleBuilder,
      itemIconBuilder: itemIconBuilder,
      itemAvatarBuilder: itemAvatarBuilder,
      itemStatusBuilder: itemStatusBuilder,
      itemTrailingBuilder: itemTrailingBuilder,
      groupBy: groupBy,
      groupHeaderBuilder: groupHeaderBuilder,
      itemBuilder: itemBuilder,
      emptyBuilder: emptyBuilder,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
      config: config,
      search: search,
      popup: popup,
      filters: filters,
      pagination: pagination,
      controller: controller,
      hintText: hintText,
      enabled: enabled,
      errorText: errorText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      trailingLabelWidget: trailingLabelWidget,
      searchHint: searchHint,
      showClearButton: showClearButton,
      maxPanelHeight: maxPanelHeight,
      loader: loader,
      debounceMs: debounceMs,
      pageSize: pageSize,
      selection: (selection ?? const SmartDropdownSelectionConfig()).copyWith(
        mode: SelectionMode.multiple,
        showSelectAll: selection?.showSelectAll ?? showSelectAll,
        showClearAll: selection?.showClearAll ?? showClearAll,
      ),
    );
  }

  /// Convenient named constructor for single-selection mode.
  factory SmartSearchDropdown.single({
    Key? key,
    List<T>? items,
    T? value,
    required ValueChanged<T?> onChanged,
    Future<List<T>> Function(String query)? asyncSearch,
    String Function(T item)? itemLabelBuilder,
    String? Function(T item)? itemSubtitleBuilder,
    Widget? Function(T item)? itemIconBuilder,
    Widget? Function(T item)? itemAvatarBuilder,
    Widget? Function(T item)? itemStatusBuilder,
    Widget? Function(T item)? itemTrailingBuilder,
    String Function(T item)? groupBy,
    Widget Function(BuildContext context, String groupName)? groupHeaderBuilder,
    Widget Function(BuildContext context, T item, SmartDropdownItemState state)? itemBuilder,
    Widget Function(BuildContext context, T item)? selectedItemBuilder,
    WidgetBuilder? emptyBuilder,
    Widget Function(BuildContext context, String error)? errorBuilder,
    WidgetBuilder? loadingBuilder,
    SmartDropdownConfig<T>? config,
    SmartDropdownSearchConfig? search,
    SmartDropdownPopupConfig? popup,
    SmartDropdownFilterConfig<T>? filters,
    SmartDropdownPaginationConfig<T>? pagination,
    SmartDropdownController<T>? controller,
    String hintText = 'Select Option',
    bool enabled = true,
    String? errorText,
    String? labelText,
    Widget? prefixIcon,
    Widget? trailingLabelWidget,
    String? searchHint,
    bool? showClearButton,
    double? maxPanelHeight,
    Future<DropdownPageResult<T>> Function(String query, int page)? loader,
    int? debounceMs,
    int? pageSize,
  }) {
    return SmartSearchDropdown<T>(
      key: key,
      items: items,
      value: value,
      onChanged: onChanged,
      asyncSearch: asyncSearch,
      itemLabelBuilder: itemLabelBuilder,
      itemSubtitleBuilder: itemSubtitleBuilder,
      itemIconBuilder: itemIconBuilder,
      itemAvatarBuilder: itemAvatarBuilder,
      itemStatusBuilder: itemStatusBuilder,
      itemTrailingBuilder: itemTrailingBuilder,
      groupBy: groupBy,
      groupHeaderBuilder: groupHeaderBuilder,
      itemBuilder: itemBuilder,
      selectedItemBuilder: selectedItemBuilder,
      emptyBuilder: emptyBuilder,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
      config: config,
      search: search,
      popup: popup,
      controller: controller,
      hintText: hintText,
      enabled: enabled,
      errorText: errorText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      trailingLabelWidget: trailingLabelWidget,
      searchHint: searchHint,
      showClearButton: showClearButton,
      maxPanelHeight: maxPanelHeight,
      loader: loader,
      debounceMs: debounceMs,
      pageSize: pageSize,
      selection: const SmartDropdownSelectionConfig(
        mode: SelectionMode.single,
      ),
    );
  }

  @override
  State<SmartSearchDropdown<T>> createState() => _SmartSearchDropdownState<T>();
}

class _SmartSearchDropdownState<T> extends State<SmartSearchDropdown<T>> {
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  late SmartDropdownController<T> _controller;
  bool _isInternalController = false;

  List<T> _currentItems = [];
  List<T> _selectedItems = [];

  bool _isLoading = false;
  String? _error;
  Timer? _debounceTimer;
  int _currentPage = 1;
  int _searchGeneration = 0;

  late SmartDropdownConfig<T> _effectiveConfig;

  @override
  void initState() {
    super.initState();
    _initConfig();
    _initController();
    _syncSelectedItems();
    _loadInitialItems();
  }

  @override
  void didUpdateWidget(covariant SmartSearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initConfig();
    _syncSelectedItems();
    if (widget.items != oldWidget.items && widget.asyncSearch == null) {
      _currentItems = List.from(widget.items ?? []);
    }
  }

  void _initConfig() {
    final baseConfig = widget.config ?? SmartDropdownConfig<T>();

    var searchConfig = widget.search ?? baseConfig.search;
    if (widget.searchHint != null) {
      searchConfig = searchConfig.copyWith(searchHintText: widget.searchHint!);
    }
    if (widget.debounceMs != null) {
      searchConfig = searchConfig.copyWith(
        debounceDuration: Duration(milliseconds: widget.debounceMs!),
      );
    }

    var popupConfig = widget.popup ?? baseConfig.popup;
    if (widget.maxPanelHeight != null) {
      popupConfig = popupConfig.copyWith(maxHeight: widget.maxPanelHeight!);
    }

    var selectionConfig = widget.selection ?? baseConfig.selection;
    if (widget.showClearButton != null) {
      selectionConfig = selectionConfig.copyWith(showClearAll: widget.showClearButton!);
    }

    var paginationConfig = widget.pagination ?? baseConfig.pagination;
    if (widget.pageSize != null) {
      paginationConfig = paginationConfig.copyWith(pageSize: widget.pageSize!);
    }
    if (widget.loader != null && paginationConfig.onLoadMore == null) {
      paginationConfig = paginationConfig.copyWith(
        enabled: true,
        onLoadMore: (page) async {
          final res = await widget.loader!(_controller.searchQuery, page);
          _controller.updateState(hasMore: res.hasMore);
          return res.items;
        },
      );
    }

    _effectiveConfig = baseConfig.copyWith(
      search: searchConfig,
      selection: selectionConfig,
      popup: popupConfig,
      filter: widget.filters ?? baseConfig.filter,
      pagination: paginationConfig,
      createOption: widget.createOption != null
          ? widget.createOption!
          : (widget.onCreateOption != null
              ? baseConfig.createOption.copyWith(
                  enabled: true,
                  onCreate: widget.onCreateOption,
                )
              : baseConfig.createOption),
      recent: widget.recent ?? baseConfig.recent,
    );
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = SmartDropdownController<T>();
      _isInternalController = true;
    }

    _controller.attachCallbacks(
      onOpen: _showOverlay,
      onClose: _hideOverlay,
      onToggle: _toggleOverlay,
      onSelect: _handleSelect,
      onDeselect: _handleDeselect,
      onSelectAll: _handleSelectAll,
      onClearAll: _handleClearAll,
      onLoadMore: _handleLoadMore,
    );
  }

  void _syncSelectedItems() {
    _selectedItems.clear();
    if (_effectiveConfig.selection.isMulti) {
      if (widget.selectedItems != null) {
        _selectedItems.addAll(widget.selectedItems!);
      }
    } else {
      if (widget.value != null) {
        _selectedItems.add(widget.value as T);
      }
    }
    _controller.setSelection(_selectedItems);
  }

  void _loadInitialItems() async {
    if (widget.items != null) {
      _currentItems = List.from(widget.items!);
    } else if (widget.loader != null) {
      _fetchLoaderQuery('', isInitial: true);
    } else if (widget.asyncSearch != null) {
      _fetchAsyncQuery('', isInitial: true);
    }
  }

  void _fetchLoaderQuery(String query, {bool isInitial = false}) async {
    final int generation = ++_searchGeneration;
    if (!isInitial && mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    } else {
      _isLoading = true;
      _error = null;
    }
    _controller.updateState(isLoading: true, error: null);
    _updateOverlayState();

    try {
      _currentPage = 1;
      final result = await widget.loader!(query, 1);
      if (_searchGeneration != generation) return;
      if (mounted) {
        setState(() {
          _currentItems = result.items;
          _isLoading = false;
        });
        _controller.updateState(isLoading: false, hasMore: result.hasMore);
        _updateOverlayState();
      }
    } catch (e) {
      if (_searchGeneration != generation) return;
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
        _controller.updateState(isLoading: false, error: _error);
        _updateOverlayState();
      }
    }
  }

  String _getItemLabel(T item) {
    if (widget.itemLabelBuilder != null) {
      return widget.itemLabelBuilder!(item);
    }
    return item.toString();
  }

  List<T> get _filteredItems {
    final query = _controller.searchQuery;
    final searchConfig = _effectiveConfig.search;

    if (widget.loader != null || widget.asyncSearch != null || query.length < searchConfig.minChars) {
      return _currentItems;
    }

    return _currentItems.where((item) {
      if (searchConfig.customSearch != null) {
        return searchConfig.customSearch!(item, query);
      }
      return SearchUtils.matches(
        label: _getItemLabel(item),
        query: query,
        searchMode: searchConfig.searchMode,
      );
    }).toList();
  }

  List<DropdownGroup<T>>? get _groupedItems {
    if (widget.groupBy == null) return null;
    final itemsToGroup = _filteredItems;
    final Map<String, List<T>> map = {};

    for (final item in itemsToGroup) {
      final category = widget.groupBy!(item);
      map.putIfAbsent(category, () => []).add(item);
    }

    return map.entries
        .map((entry) => DropdownGroup<T>(name: entry.key, items: entry.value))
        .toList();
  }

  List<RecentPopularItem<T>>? get _recentPopularItems {
    final recentConfig = _effectiveConfig.recent;
    if (!recentConfig.enabled || _controller.searchQuery.isNotEmpty) return null;

    final List<RecentPopularItem<T>> list = [];
    if (recentConfig.recentItems != null) {
      for (final item in recentConfig.recentItems!) {
        list.add(RecentPopularItem(item: item, type: RecentPopularType.recent));
      }
    }
    if (recentConfig.popularItems != null) {
      for (final item in recentConfig.popularItems!) {
        list.add(RecentPopularItem(item: item, type: RecentPopularType.popular));
      }
    }

    return list.isNotEmpty ? list : null;
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _controller.setSearchQuery(query);
    _effectiveConfig.search.onSearchChanged?.call(query);

    if (widget.loader != null) {
      _debounceTimer = Timer(_effectiveConfig.search.debounceDuration, () {
        _fetchLoaderQuery(query);
      });
    } else if (widget.asyncSearch != null) {
      _debounceTimer = Timer(_effectiveConfig.search.debounceDuration, () {
        _fetchAsyncQuery(query);
      });
    } else {
      if (mounted) setState(() {});
      _updateOverlayState();
    }
  }

  void _fetchAsyncQuery(String query, {bool isInitial = false}) async {
    final int generation = ++_searchGeneration;
    if (!isInitial && mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    } else {
      _isLoading = true;
      _error = null;
    }
    _controller.updateState(isLoading: true, error: null);
    _updateOverlayState();

    try {
      final results = await widget.asyncSearch!(query);
      if (_searchGeneration != generation) return;
      if (mounted) {
        setState(() {
          _currentItems = results;
          _isLoading = false;
        });
        _controller.updateState(isLoading: false);
        _updateOverlayState();
      }
    } catch (e) {
      if (_searchGeneration != generation) return;
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
        _controller.updateState(isLoading: false, error: _error);
        _updateOverlayState();
      }
    }
  }

  Future<void> _handleLoadMore() async {
    if (widget.asyncSearch == null && _effectiveConfig.pagination.onLoadMore == null) return;
    try {
      _currentPage++;
      final newItems = await _effectiveConfig.pagination.onLoadMore?.call(_currentPage);
      if (newItems != null && newItems.isNotEmpty) {
        setState(() {
          _currentItems.addAll(newItems);
        });
        _updateOverlayState();
      } else {
        _controller.updateState(hasMore: false);
      }
    } catch (_) {
      _controller.updateState(hasMore: false);
    }
  }

  void _handleSelect(T item) {
    if (widget.isItemEnabled != null && !widget.isItemEnabled!(item)) return;

    if (_effectiveConfig.selection.isMulti) {
      final max = _effectiveConfig.selection.maxSelections;
      if (!_selectedItems.contains(item)) {
        if (max != null && _selectedItems.length >= max) return;
        setState(() {
          _selectedItems.add(item);
        });
        widget.onMultiChanged?.call(List.unmodifiable(_selectedItems));
      }
      _updateOverlayState();
    } else {
      setState(() {
        _selectedItems = [item];
      });
      widget.onChanged?.call(item);
      _effectiveConfig.recent.storage?.addRecent(item);
      _hideOverlay();
    }
  }

  void _handleDeselect(T item) {
    if (_effectiveConfig.selection.isMulti) {
      final min = _effectiveConfig.selection.minSelections;
      if (min != null && _selectedItems.length <= min) return;
      setState(() {
        _selectedItems.remove(item);
      });
      widget.onMultiChanged?.call(List.unmodifiable(_selectedItems));
      _updateOverlayState();
    }
  }

  void _handleSelectAll() {
    final available = _filteredItems.where((i) => widget.isItemEnabled?.call(i) ?? true).toList();
    if (_selectedItems.length >= available.length) {
      _handleClearAll();
    } else {
      setState(() {
        _selectedItems = List.from(available);
      });
      widget.onMultiChanged?.call(List.unmodifiable(_selectedItems));
      _updateOverlayState();
    }
  }

  void _handleClearAll() {
    setState(() {
      _selectedItems.clear();
    });
    if (_effectiveConfig.selection.isMulti) {
      widget.onMultiChanged?.call(const []);
    } else {
      widget.onChanged?.call(null);
    }
    _updateOverlayState();
  }

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null || !widget.enabled) return;

    final RenderBox? renderBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final screenSize = MediaQuery.of(context).size;
    final presentation = _effectiveConfig.popup.presentation;

    final bool isMobile = screenSize.width < _effectiveConfig.popup.mobileBreakpoint;

    if (presentation == DropdownPresentation.bottomSheet ||
        (presentation == DropdownPresentation.adaptive && isMobile)) {
      _showBottomSheetModal();
      return;
    }

    if (presentation == DropdownPresentation.dialog) {
      _showDialogModal();
      return;
    }

    final posResult = DropdownPositionCalculator.calculate(
      context: context,
      targetRenderBox: renderBox,
      preferredMaxHeight: _effectiveConfig.popup.maxHeight,
      verticalOffset: _effectiveConfig.popup.offset,
      customWidth: _effectiveConfig.popup.width,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _hideOverlay,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: posResult.offset.dx,
            top: posResult.offset.dy,
            width: posResult.width,
            child: SmartDropdownPopup<T>(
              config: _effectiveConfig.copyWith(
                popup: _effectiveConfig.popup.copyWith(
                  maxHeight: posResult.maxHeight,
                ),
              ),
              items: _filteredItems,
              groupedItems: _groupedItems,
              recentPopularItems: _recentPopularItems,
              selectedItems: _selectedItems,
              controller: _controller,
              labelBuilder: _getItemLabel,
              subtitleBuilder: widget.itemSubtitleBuilder,
              iconBuilder: widget.itemIconBuilder,
              avatarBuilder: widget.itemAvatarBuilder,
              statusBuilder: widget.itemStatusBuilder,
              trailingBuilder: widget.itemTrailingBuilder,
              itemBuilder: widget.itemBuilder,
              groupHeaderBuilder: widget.groupHeaderBuilder,
              emptyBuilder: widget.emptyBuilder,
              errorBuilder: widget.errorBuilder,
              loadingBuilder: widget.loadingBuilder,
              onItemTap: (item) {
                if (_selectedItems.contains(item)) {
                  _handleDeselect(item);
                } else {
                  _handleSelect(item);
                }
              },
              onSearchChanged: _onSearchChanged,
              onClearSearch: () => _onSearchChanged(''),
              onToggleSelectAll: _handleSelectAll,
              onClearAll: _handleClearAll,
              onCreateOption: (q) async {
                final created = await widget.onCreateOption?.call(q);
                if (created != null) {
                  _handleSelect(created);
                }
              },
              isLoading: _isLoading,
              error: _error,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
    _controller.updateState(isOpen: true);
  }

  void _showBottomSheetModal() {
    _controller.updateState(isOpen: true);
    setState(() {});

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SmartDropdownPopup<T>(
            config: _effectiveConfig,
            items: _filteredItems,
            groupedItems: _groupedItems,
            recentPopularItems: _recentPopularItems,
            selectedItems: _selectedItems,
            controller: _controller,
            labelBuilder: _getItemLabel,
            subtitleBuilder: widget.itemSubtitleBuilder,
            iconBuilder: widget.itemIconBuilder,
            avatarBuilder: widget.itemAvatarBuilder,
            statusBuilder: widget.itemStatusBuilder,
            trailingBuilder: widget.itemTrailingBuilder,
            itemBuilder: widget.itemBuilder,
            groupHeaderBuilder: widget.groupHeaderBuilder,
            emptyBuilder: widget.emptyBuilder,
            errorBuilder: widget.errorBuilder,
            loadingBuilder: widget.loadingBuilder,
            onItemTap: (item) {
              if (_selectedItems.contains(item)) {
                _handleDeselect(item);
              } else {
                _handleSelect(item);
              }
              if (!_effectiveConfig.selection.isMulti) {
                Navigator.of(ctx).pop();
              }
            },
            onSearchChanged: _onSearchChanged,
            onClearSearch: () => _onSearchChanged(''),
            onToggleSelectAll: _handleSelectAll,
            onClearAll: _handleClearAll,
            onCreateOption: (q) async {
              final created = await widget.onCreateOption?.call(q);
              if (created != null) {
                _handleSelect(created);
              }
            },
            isLoading: _isLoading,
            error: _error,
            isMobileModal: true,
            onCloseModal: () => Navigator.of(ctx).pop(),
          ),
        );
      },
    ).then((_) {
      _controller.updateState(isOpen: false);
      if (mounted) setState(() {});
    });
  }

  void _showDialogModal() {
    _controller.updateState(isOpen: true);
    setState(() {});

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SmartDropdownPopup<T>(
            config: _effectiveConfig,
            items: _filteredItems,
            groupedItems: _groupedItems,
            recentPopularItems: _recentPopularItems,
            selectedItems: _selectedItems,
            controller: _controller,
            labelBuilder: _getItemLabel,
            subtitleBuilder: widget.itemSubtitleBuilder,
            iconBuilder: widget.itemIconBuilder,
            avatarBuilder: widget.itemAvatarBuilder,
            statusBuilder: widget.itemStatusBuilder,
            trailingBuilder: widget.itemTrailingBuilder,
            itemBuilder: widget.itemBuilder,
            groupHeaderBuilder: widget.groupHeaderBuilder,
            emptyBuilder: widget.emptyBuilder,
            errorBuilder: widget.errorBuilder,
            loadingBuilder: widget.loadingBuilder,
            onItemTap: (item) {
              if (_selectedItems.contains(item)) {
                _handleDeselect(item);
              } else {
                _handleSelect(item);
              }
              if (!_effectiveConfig.selection.isMulti) {
                Navigator.of(ctx).pop();
              }
            },
            onSearchChanged: _onSearchChanged,
            onClearSearch: () => _onSearchChanged(''),
            onToggleSelectAll: _handleSelectAll,
            onClearAll: _handleClearAll,
            onCreateOption: (q) async {
              final created = await widget.onCreateOption?.call(q);
              if (created != null) {
                _handleSelect(created);
              }
            },
            isLoading: _isLoading,
            error: _error,
            isMobileModal: true,
            onCloseModal: () => Navigator.of(ctx).pop(),
          ),
        );
      },
    ).then((_) {
      _controller.updateState(isOpen: false);
      if (mounted) setState(() {});
    });
  }

  void _updateOverlayState() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _controller.updateState(isOpen: false);
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _hideOverlay();
    if (_isInternalController) {
      _controller.dispose();
    } else {
      _controller.detachCallbacks();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final T? singleSelection = _selectedItems.isNotEmpty ? _selectedItems.first : null;

    return SmartDropdownTrigger<T>(
      key: _triggerKey,
      selectedItem: singleSelection,
      selectedItems: _selectedItems,
      hintText: widget.hintText,
      isOpen: _controller.isOpen,
      enabled: widget.enabled,
      errorText: widget.errorText,
      selectionConfig: _effectiveConfig.selection,
      labelBuilder: _getItemLabel,
      iconBuilder: widget.itemIconBuilder,
      avatarBuilder: widget.itemAvatarBuilder,
      selectedItemBuilder: widget.selectedItemBuilder,
      prefixIcon: widget.prefixIcon,
      labelText: widget.labelText,
      trailingLabelWidget: widget.trailingLabelWidget,
      showClearButton: widget.showClearButton ?? true,
      onTap: _toggleOverlay,
      onClear: _handleClearAll,
      onRemoveChip: _handleDeselect,
    );
  }
}
