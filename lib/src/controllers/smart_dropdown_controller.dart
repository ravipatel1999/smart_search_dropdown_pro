import 'package:flutter/material.dart';

/// Programmatic controller for controlling and listening to state changes in a [SmartSearchDropdown].
class SmartDropdownController<T> extends ChangeNotifier {
  bool _isOpen = false;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  final List<T> _selectedItems = [];

  // Action callbacks attached by active SmartSearchDropdown widget instance
  VoidCallback? _onOpenCallback;
  VoidCallback? _onCloseCallback;
  VoidCallback? _onToggleCallback;
  VoidCallback? _onFocusSearchCallback;
  VoidCallback? _onRefreshCallback;
  Future<void> Function()? _onLoadMoreCallback;
  void Function(T item)? _onSelectCallback;
  void Function(T item)? _onDeselectCallback;
  VoidCallback? _onSelectAllCallback;
  VoidCallback? _onClearAllCallback;

  SmartDropdownController({List<T>? initialSelection}) {
    if (initialSelection != null) {
      _selectedItems.addAll(initialSelection);
    }
  }

  /// Whether the dropdown popup is currently open.
  bool get isOpen => _isOpen;

  /// Current search query text.
  bool get isLoading => _isLoading;

  /// Whether more async paginated items are available.
  bool get hasMore => _hasMore;

  /// Current active error message if any.
  String? get error => _error;

  /// Currently active search query text.
  String get searchQuery => _searchQuery;

  /// Returns the first selected item in single selection mode or null.
  T? get selectedItem => _selectedItems.isNotEmpty ? _selectedItems.first : null;

  /// Unmodifiable list of currently selected items.
  List<T> get selectedItems => List.unmodifiable(_selectedItems);

  /// Opens the dropdown overlay programmatically.
  void open() {
    if (!_isOpen) {
      _isOpen = true;
      _onOpenCallback?.call();
      notifyListeners();
    }
  }

  /// Closes the dropdown overlay programmatically.
  void close() {
    if (_isOpen) {
      _isOpen = false;
      _onCloseCallback?.call();
      notifyListeners();
    }
  }

  /// Toggles popup open/closed state.
  void toggle() {
    if (_isOpen) {
      close();
    } else {
      open();
    }
    _onToggleCallback?.call();
  }

  /// Selects a single item.
  void select(T item) {
    if (!_selectedItems.contains(item)) {
      _selectedItems.add(item);
      _onSelectCallback?.call(item);
      notifyListeners();
    }
  }

  /// Deselects an item.
  void deselect(T item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
      _onDeselectCallback?.call(item);
      notifyListeners();
    }
  }

  /// Replaces selection with new list of items.
  void setSelection(List<T> items) {
    _selectedItems.clear();
    _selectedItems.addAll(items);
    notifyListeners();
  }

  /// Selects all items in multi-select mode.
  void selectAll(List<T> allItems) {
    _selectedItems.clear();
    _selectedItems.addAll(allItems);
    _onSelectAllCallback?.call();
    notifyListeners();
  }

  /// Clears all selected items.
  void clearAll() {
    if (_selectedItems.isNotEmpty) {
      _selectedItems.clear();
      _onClearAllCallback?.call();
      notifyListeners();
    }
  }

  /// Clears search query and selection.
  void clear() {
    _searchQuery = '';
    _selectedItems.clear();
    notifyListeners();
  }

  /// Focuses the search text input inside open popup.
  void focusSearch() {
    _onFocusSearchCallback?.call();
  }

  /// Clears the current search text query.
  void clearSearch() {
    if (_searchQuery.isNotEmpty) {
      _searchQuery = '';
      notifyListeners();
    }
  }

  /// Sets active search query.
  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  /// Triggers refresh callback for async search/load.
  void refresh() {
    _onRefreshCallback?.call();
  }

  /// Triggers load more callback for async pagination.
  Future<void> loadMore() async {
    if (_onLoadMoreCallback != null) {
      await _onLoadMoreCallback!.call();
    }
  }

  /// Internal status updates used by widget component.
  void updateState({
    bool? isOpen,
    String? searchQuery,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    bool changed = false;
    if (isOpen != null && _isOpen != isOpen) {
      _isOpen = isOpen;
      changed = true;
    }
    if (searchQuery != null && _searchQuery != searchQuery) {
      _searchQuery = searchQuery;
      changed = true;
    }
    if (isLoading != null && _isLoading != isLoading) {
      _isLoading = isLoading;
      changed = true;
    }
    if (hasMore != null && _hasMore != hasMore) {
      _hasMore = hasMore;
      changed = true;
    }
    if (error != _error) {
      _error = error;
      changed = true;
    }
    if (changed) {
      notifyListeners();
    }
  }

  /// Binds widget callbacks to controller.
  void attachCallbacks({
    VoidCallback? onOpen,
    VoidCallback? onClose,
    VoidCallback? onToggle,
    VoidCallback? onFocusSearch,
    VoidCallback? onRefresh,
    Future<void> Function()? onLoadMore,
    void Function(T item)? onSelect,
    void Function(T item)? onDeselect,
    VoidCallback? onSelectAll,
    VoidCallback? onClearAll,
  }) {
    _onOpenCallback = onOpen;
    _onCloseCallback = onClose;
    _onToggleCallback = onToggle;
    _onFocusSearchCallback = onFocusSearch;
    _onRefreshCallback = onRefresh;
    _onLoadMoreCallback = onLoadMore;
    _onSelectCallback = onSelect;
    _onDeselectCallback = onDeselect;
    _onSelectAllCallback = onSelectAll;
    _onClearAllCallback = onClearAll;
  }

  /// Unbinds widget callbacks.
  void detachCallbacks() {
    _onOpenCallback = null;
    _onCloseCallback = null;
    _onToggleCallback = null;
    _onFocusSearchCallback = null;
    _onRefreshCallback = null;
    _onLoadMoreCallback = null;
    _onSelectCallback = null;
    _onDeselectCallback = null;
    _onSelectAllCallback = null;
    _onClearAllCallback = null;
  }
}
