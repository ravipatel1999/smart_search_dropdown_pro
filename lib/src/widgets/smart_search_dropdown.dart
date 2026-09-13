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
import '../enums/search_empty_query_behavior.dart';
import '../enums/selection_mode.dart';
import '../models/dropdown_group.dart';
import '../models/dropdown_item_state.dart';
import '../models/recent_popular_item.dart';
import '../utilities/dropdown_position.dart';
import '../utilities/search_utils.dart';
import 'smart_dropdown_popup.dart';
import 'smart_dropdown_trigger.dart';

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

  /// Async paginated search callback receiving active query and 1-indexed page.
  final Future<List<T>> Function(String query, int page)? asyncPaginatedSearch;

  /// Stable item ID extractor for deduplicating items across pages and selections.
  final dynamic Function(T item)? itemIdExtractor;

  /// Callback fired when initial search encounters an error.
  final ValueChanged<String>? onSearchError;

  /// Callback fired when pagination loading encounters an error.
  final ValueChanged<String>? onPaginationError;

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

  const SmartSearchDropdown({
    super.key,
    this.items,
    this.value,
    this.selectedItems,
    this.onChanged,
    this.onMultiChanged,
    this.asyncSearch,
    this.asyncPaginatedSearch,
    this.itemIdExtractor,
    this.onSearchError,
    this.onPaginationError,
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
  });

  /// Convenient named constructor for multi-selection mode.
  factory SmartSearchDropdown.multi({
    Key? key,
    List<T>? items,
    List<T>? selectedItems,
    required ValueChanged<List<T>> onMultiChanged,
    Future<List<T>> Function(String query)? asyncSearch,
    Future<List<T>> Function(String query, int page)? asyncPaginatedSearch,
    dynamic Function(T item)? itemIdExtractor,
    ValueChanged<String>? onSearchError,
    ValueChanged<String>? onPaginationError,
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
    int? maxSelections,
    int? minSelections,
  }) {
    return SmartSearchDropdown<T>(
      key: key,
      items: items,
      selectedItems: selectedItems,
      onMultiChanged: onMultiChanged,
      asyncSearch: asyncSearch,
      asyncPaginatedSearch: asyncPaginatedSearch,
      itemIdExtractor: itemIdExtractor,
      onSearchError: onSearchError,
      onPaginationError: onPaginationError,
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
      selection: SmartDropdownSelectionConfig(
        mode: SelectionMode.multiple,
        showSelectAll: showSelectAll,
        showClearAll: showClearAll,
        maxSelections: maxSelections,
        minSelections: minSelections,
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
    Future<List<T>> Function(String query, int page)? asyncPaginatedSearch,
    dynamic Function(T item)? itemIdExtractor,
    ValueChanged<String>? onSearchError,
    ValueChanged<String>? onPaginationError,
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
  }) {
    return SmartSearchDropdown<T>(
      key: key,
      items: items,
      value: value,
      onChanged: onChanged,
      asyncSearch: asyncSearch,
      asyncPaginatedSearch: asyncPaginatedSearch,
      itemIdExtractor: itemIdExtractor,
      onSearchError: onSearchError,
      onPaginationError: onPaginationError,
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
  NavigatorState? _modalNavigator;
  bool _isModalOpen = false;

  late SmartDropdownController<T> _controller;
  bool _isInternalController = false;

  List<T> _currentItems = [];
  List<T> _selectedItems = [];

  bool _isLoadingInitial = false;
  bool _isLoadingMore = false;
  String? _error;
  String? _paginationError;
  Timer? _debounceTimer;
  int _currentPage = 1;
  bool _hasMore = true;

  /// Monotonically increasing generation counter to protect against async race conditions.
  int _searchGeneration = 0;

  /// Tracks the last executed query comparison string to prevent redundant network calls.
  String? _lastExecutedNormalizedQuery;

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
    if (widget.items != oldWidget.items &&
        widget.asyncSearch == null &&
        widget.asyncPaginatedSearch == null) {
      _currentItems = List.from(widget.items ?? []);
    }
  }

  void _initConfig() {
    final baseConfig = widget.config ?? SmartDropdownConfig<T>();
    _effectiveConfig = baseConfig.copyWith(
      search: widget.search ?? baseConfig.search,
      selection: widget.selection ?? baseConfig.selection,
      popup: widget.popup ?? baseConfig.popup,
      filter: widget.filters ?? baseConfig.filter,
      pagination: widget.pagination ?? baseConfig.pagination,
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
      onRetry: _retrySearch,
      onRetryPagination: _retryPagination,
      onRefresh: _refresh,
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

  void _loadInitialItems() {
    if (widget.items != null) {
      _currentItems = List.from(widget.items!);
    } else if (widget.asyncPaginatedSearch != null || widget.asyncSearch != null) {
      if (_effectiveConfig.search.emptyQueryBehavior ==
          SearchEmptyQueryBehavior.callRemoteApi) {
        _fetchAsyncQuery('');
      }
    }
  }

  String _getItemLabel(T item) {
    if (widget.itemLabelBuilder != null) {
      return widget.itemLabelBuilder!(item);
    }
    return item.toString();
  }

  String _normalizeQuery(String query) {
    String q = query;
    if (_effectiveConfig.search.trimQuery) {
      q = q.trim();
    }
    return q;
  }

  String _comparableQuery(String query) {
    final q = _normalizeQuery(query);
    return _effectiveConfig.search.caseSensitive ? q : q.toLowerCase();
  }

  List<T> get _filteredItems {
    final query = _controller.searchQuery;
    final searchConfig = _effectiveConfig.search;

    if (widget.asyncSearch != null ||
        widget.asyncPaginatedSearch != null ||
        query.length < searchConfig.minChars) {
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

  void _onSearchChanged(String rawQuery) {
    _debounceTimer?.cancel();
    _controller.setSearchQuery(rawQuery);

    final bool isRemote =
        widget.asyncSearch != null || widget.asyncPaginatedSearch != null;

    if (!isRemote) {
      if (mounted) setState(() {});
      _updateOverlayState();
      return;
    }

    final normalized = _normalizeQuery(rawQuery);
    final comparable = _comparableQuery(rawQuery);

    // Handle empty query according to configuration
    if (normalized.isEmpty) {
      _searchGeneration++;
      _lastExecutedNormalizedQuery = comparable;

      switch (_effectiveConfig.search.emptyQueryBehavior) {
        case SearchEmptyQueryBehavior.showInitialItems:
          setState(() {
            _currentItems = widget.items != null ? List.from(widget.items!) : [];
            _isLoadingInitial = false;
            _isLoadingMore = false;
            _error = null;
            _paginationError = null;
            _currentPage = 1;
            _hasMore = true;
          });
          _controller.updateState(
            items: _currentItems,
            isLoadingInitial: false,
            isLoadingMore: false,
            error: null,
            paginationError: null,
            currentPage: 1,
            hasMore: true,
            searchGeneration: _searchGeneration,
          );
          _updateOverlayState();
          return;

        case SearchEmptyQueryBehavior.clearResults:
          setState(() {
            _currentItems = [];
            _isLoadingInitial = false;
            _isLoadingMore = false;
            _error = null;
            _paginationError = null;
            _currentPage = 1;
            _hasMore = true;
          });
          _controller.updateState(
            items: _currentItems,
            isLoadingInitial: false,
            isLoadingMore: false,
            error: null,
            paginationError: null,
            currentPage: 1,
            hasMore: true,
            searchGeneration: _searchGeneration,
          );
          _updateOverlayState();
          return;

        case SearchEmptyQueryBehavior.callRemoteApi:
          break;
      }
    }

    if (normalized.length < _effectiveConfig.search.minChars && normalized.isNotEmpty) {
      _searchGeneration++;
      return;
    }

    // Prevent duplicate request if unchanged and not in an error state
    if (comparable == _lastExecutedNormalizedQuery && _error == null) {
      return;
    }

    final duration = _effectiveConfig.search.debounceDuration;
    if (duration == Duration.zero) {
      _fetchAsyncQuery(normalized);
    } else {
      _debounceTimer = Timer(duration, () {
        _fetchAsyncQuery(normalized);
      });
    }
  }

  void _fetchAsyncQuery(String query) async {
    final normalized = _normalizeQuery(query);
    _lastExecutedNormalizedQuery = _comparableQuery(query);

    _searchGeneration++;
    final int generation = _searchGeneration;

    if (_effectiveConfig.search.logDebug) {
      debugPrint('[SmartDropdown] SEARCH START query="$normalized" generation=$generation');
    }

    setState(() {
      _isLoadingInitial = true;
      _isLoadingMore = false;
      _error = null;
      _paginationError = null;
      _currentPage = 1;
      _hasMore = true;
    });
    _controller.updateState(
      isLoadingInitial: true,
      isLoadingMore: false,
      error: null,
      paginationError: null,
      currentPage: 1,
      hasMore: true,
      searchGeneration: generation,
    );
    _updateOverlayState();

    try {
      List<T> results;
      if (widget.asyncPaginatedSearch != null) {
        results = await widget.asyncPaginatedSearch!(normalized, 1);
      } else if (widget.asyncSearch != null) {
        results = await widget.asyncSearch!(normalized);
      } else {
        results = [];
      }

      if (!mounted || generation != _searchGeneration) {
        if (_effectiveConfig.search.logDebug) {
          debugPrint(
              '[SmartDropdown] STALE RESPONSE IGNORED query="$normalized" generation=$generation currentGeneration=$_searchGeneration');
        }
        return;
      }

      final bool hasMorePages = widget.asyncPaginatedSearch != null
          ? results.length >= _effectiveConfig.pagination.pageSize
          : (_effectiveConfig.pagination.enabled
              ? results.length >= _effectiveConfig.pagination.pageSize
              : false);

      setState(() {
        _currentItems = results;
        _isLoadingInitial = false;
        _hasMore = hasMorePages;
      });
      _controller.updateState(
        items: _currentItems,
        isLoadingInitial: false,
        hasMore: hasMorePages,
      );
      _updateOverlayState();

      if (_effectiveConfig.search.logDebug) {
        debugPrint(
            '[SmartDropdown] SEARCH SUCCESS query="$normalized" generation=$generation count=${results.length}');
      }
    } catch (e) {
      if (!mounted || generation != _searchGeneration) {
        if (_effectiveConfig.search.logDebug) {
          debugPrint(
              '[SmartDropdown] STALE ERROR IGNORED query="$normalized" generation=$generation currentGeneration=$_searchGeneration');
        }
        return;
      }

      final errorMsg = e.toString();
      setState(() {
        _error = errorMsg;
        _isLoadingInitial = false;
      });
      _controller.updateState(
        isLoadingInitial: false,
        error: errorMsg,
      );
      _updateOverlayState();
      widget.onSearchError?.call(errorMsg);

      if (_effectiveConfig.search.logDebug) {
        debugPrint(
            '[SmartDropdown] SEARCH ERROR query="$normalized" generation=$generation error=$errorMsg');
      }
    }
  }

  Future<void> _handleLoadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoadingInitial) return;
    if (widget.asyncPaginatedSearch == null &&
        _effectiveConfig.pagination.onLoadMoreWithQuery == null &&
        _effectiveConfig.pagination.onLoadMore == null) {
      return;
    }

    final int generation = _searchGeneration;
    final int targetPage = _currentPage + 1;
    final String query = _normalizeQuery(_controller.searchQuery);

    if (_effectiveConfig.search.logDebug) {
      debugPrint(
          '[SmartDropdown] PAGE REQUEST query="$query" page=$targetPage generation=$generation');
    }

    setState(() {
      _isLoadingMore = true;
      _paginationError = null;
    });
    _controller.updateState(
      isLoadingMore: true,
      paginationError: null,
    );
    _updateOverlayState();

    try {
      List<T>? newItems;
      if (widget.asyncPaginatedSearch != null) {
        newItems = await widget.asyncPaginatedSearch!(query, targetPage);
      } else if (_effectiveConfig.pagination.onLoadMoreWithQuery != null) {
        newItems =
            await _effectiveConfig.pagination.onLoadMoreWithQuery!(targetPage, query);
      } else if (_effectiveConfig.pagination.onLoadMore != null) {
        newItems = await _effectiveConfig.pagination.onLoadMore!(targetPage);
      }

      if (!mounted || generation != _searchGeneration) {
        if (_effectiveConfig.search.logDebug) {
          debugPrint(
              '[SmartDropdown] PAGE RESPONSE IGNORED page=$targetPage generation=$generation currentGeneration=$_searchGeneration');
        }
        return;
      }

      if (newItems != null && newItems.isNotEmpty) {
        final merged = _mergeItems(_currentItems, newItems);
        final bool hasMorePages = newItems.length >= _effectiveConfig.pagination.pageSize;

        setState(() {
          _currentItems = merged;
          _currentPage = targetPage;
          _hasMore = hasMorePages;
          _isLoadingMore = false;
        });
        _controller.updateState(
          items: _currentItems,
          isLoadingMore: false,
          currentPage: targetPage,
          hasMore: hasMorePages,
        );
        _updateOverlayState();

        if (_effectiveConfig.search.logDebug) {
          debugPrint(
              '[SmartDropdown] PAGE SUCCESS page=$targetPage count=${newItems.length} total=${merged.length}');
        }
      } else {
        setState(() {
          _hasMore = false;
          _isLoadingMore = false;
        });
        _controller.updateState(
          isLoadingMore: false,
          hasMore: false,
        );
        _updateOverlayState();
      }
    } catch (e) {
      if (!mounted || generation != _searchGeneration) {
        if (_effectiveConfig.search.logDebug) {
          debugPrint(
              '[SmartDropdown] PAGE ERROR IGNORED page=$targetPage generation=$generation currentGeneration=$_searchGeneration');
        }
        return;
      }

      final errorMsg = e.toString();
      setState(() {
        _paginationError = errorMsg;
        _isLoadingMore = false;
      });
      _controller.updateState(
        isLoadingMore: false,
        paginationError: errorMsg,
      );
      _updateOverlayState();
      widget.onPaginationError?.call(errorMsg);

      if (_effectiveConfig.search.logDebug) {
        debugPrint(
            '[SmartDropdown] PAGE ERROR page=$targetPage generation=$generation error=$errorMsg');
      }
    }
  }

  void _retrySearch() {
    final query = _controller.searchQuery;
    _fetchAsyncQuery(query);
  }

  void _retryPagination() {
    _handleLoadMore();
  }

  void _refresh() {
    final query = _controller.searchQuery;
    _fetchAsyncQuery(query);
  }

  List<T> _mergeItems(List<T> existing, List<T> incoming) {
    if (!_effectiveConfig.pagination.preventDuplicates) {
      return [...existing, ...incoming];
    }

    final extractor = widget.itemIdExtractor ?? _effectiveConfig.pagination.itemIdExtractor;
    if (extractor != null) {
      final seenKeys = existing.map(extractor).toSet();
      final uniqueIncoming = <T>[];
      for (final item in incoming) {
        final key = extractor(item);
        if (key == null || seenKeys.add(key)) {
          uniqueIncoming.add(item);
        }
      }
      return [...existing, ...uniqueIncoming];
    } else {
      final existingSet = existing.toSet();
      final uniqueIncoming =
          incoming.where((item) => !existingSet.contains(item)).toList();
      return [...existing, ...uniqueIncoming];
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
    final available =
        _filteredItems.where((i) => widget.isItemEnabled?.call(i) ?? true).toList();
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
            child: AnimatedBuilder(
              animation: _controller,
              builder: (ctx, _) => SmartDropdownPopup<T>(
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
                isLoadingInitial: _isLoadingInitial,
                isLoadingMore: _isLoadingMore,
                error: _error,
                paginationError: _paginationError,
                onRetry: _retrySearch,
                onRetryPagination: _retryPagination,
                isRemoteSearch:
                    widget.asyncSearch != null || widget.asyncPaginatedSearch != null,
              ),
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
    _isModalOpen = true;
    _modalNavigator = Navigator.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (ctx, _) => Padding(
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
              isLoadingInitial: _isLoadingInitial,
              isLoadingMore: _isLoadingMore,
              error: _error,
              paginationError: _paginationError,
              onRetry: _retrySearch,
              onRetryPagination: _retryPagination,
              isRemoteSearch:
                  widget.asyncSearch != null || widget.asyncPaginatedSearch != null,
              isMobileModal: true,
              onCloseModal: () => Navigator.of(ctx).pop(),
            ),
          ),
        );
      },
    ).then((_) {
      _isModalOpen = false;
      _modalNavigator = null;
      _controller.updateState(isOpen: false);
      if (mounted) setState(() {});
    });
  }

  void _showDialogModal() {
    _controller.updateState(isOpen: true);
    setState(() {});
    _isModalOpen = true;
    _modalNavigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (ctx) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (ctx, _) => Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
              isLoadingInitial: _isLoadingInitial,
              isLoadingMore: _isLoadingMore,
              error: _error,
              paginationError: _paginationError,
              onRetry: _retrySearch,
              onRetryPagination: _retryPagination,
              isRemoteSearch:
                  widget.asyncSearch != null || widget.asyncPaginatedSearch != null,
              isMobileModal: true,
              onCloseModal: () => Navigator.of(ctx).pop(),
            ),
          ),
        );
      },
    ).then((_) {
      _isModalOpen = false;
      _modalNavigator = null;
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
    if (_isModalOpen && _modalNavigator != null && _modalNavigator!.mounted) {
      _isModalOpen = false;
      _modalNavigator!.pop();
      _modalNavigator = null;
    }
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _controller.updateState(isOpen: false);
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _searchGeneration++;
    _debounceTimer?.cancel();
    if (_isModalOpen && _modalNavigator != null && _modalNavigator!.mounted) {
      final nav = _modalNavigator!;
      _isModalOpen = false;
      _modalNavigator = null;
      Future.microtask(() {
        if (nav.mounted) nav.pop();
      });
    }
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    if (_isInternalController) {
      _controller.dispose();
    } else {
      _controller.detachCallbacks();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final T? singleSelection =
        _selectedItems.isNotEmpty ? _selectedItems.first : null;

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
      onTap: _toggleOverlay,
      onClear: _handleClearAll,
      onRemoveChip: _handleDeselect,
    );
  }
}
