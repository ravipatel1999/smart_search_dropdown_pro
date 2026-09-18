import 'package:flutter/foundation.dart';

/// Controller for managing state and programmatically controlling [SmartSearchDropdown].
class SmartDropdownController<T> extends ChangeNotifier {
  final List<T> _selectedItems = [];
  bool _isOpen = false;
  String _searchQuery = '';
  bool _hasMore = true;

  VoidCallback? _onOpen;
  VoidCallback? _onClose;
  VoidCallback? _onToggle;
  ValueChanged<T>? _onSelect;
  ValueChanged<T>? _onDeselect;
  Function? _onSelectAll;
  VoidCallback? _onClearAll;
  Function? _onLoadMore;

  SmartDropdownController({List<T>? initialSelection}) {
    if (initialSelection != null) {
      _selectedItems.addAll(initialSelection);
    }
  }

  bool get isOpen => _isOpen;
  String get searchQuery => _searchQuery;
  bool get hasMore => _hasMore;
  T? get selectedItem =>
      _selectedItems.isNotEmpty ? _selectedItems.first : null;
  List<T> get selectedItems => List.unmodifiable(_selectedItems);

  VoidCallback? _onRefresh;
  VoidCallback? _onFocusSearch;
  VoidCallback? _onBlurSearch;

  void attachCallbacks({
    VoidCallback? onOpen,
    VoidCallback? onClose,
    VoidCallback? onToggle,
    ValueChanged<T>? onSelect,
    ValueChanged<T>? onDeselect,
    Function? onSelectAll,
    VoidCallback? onClearAll,
    Function? onLoadMore,
    VoidCallback? onRefresh,
    VoidCallback? onFocusSearch,
    VoidCallback? onBlurSearch,
  }) {
    _onOpen = onOpen;
    _onClose = onClose;
    _onToggle = onToggle;
    _onSelect = onSelect;
    _onDeselect = onDeselect;
    _onSelectAll = onSelectAll;
    _onClearAll = onClearAll;
    _onLoadMore = onLoadMore;
    _onRefresh = onRefresh;
    _onFocusSearch = onFocusSearch;
    _onBlurSearch = onBlurSearch;
  }

  void detachCallbacks() {
    _onOpen = null;
    _onClose = null;
    _onToggle = null;
    _onSelect = null;
    _onDeselect = null;
    _onSelectAll = null;
    _onClearAll = null;
    _onLoadMore = null;
    _onRefresh = null;
    _onFocusSearch = null;
    _onBlurSearch = null;
  }

  void open() {
    _isOpen = true;
    _onOpen?.call();
    notifyListeners();
  }

  void close() {
    _isOpen = false;
    _onClose?.call();
    notifyListeners();
  }

  void toggle() {
    _isOpen = !_isOpen;
    _onToggle?.call();
    notifyListeners();
  }

  void select(T item) {
    if (!_selectedItems.contains(item)) {
      _selectedItems.add(item);
    }
    _onSelect?.call(item);
    notifyListeners();
  }

  void deselect(T item) {
    _selectedItems.remove(item);
    _onDeselect?.call(item);
    notifyListeners();
  }

  void selectAll(List<T> items) {
    _selectedItems.clear();
    _selectedItems.addAll(items);
    if (_onSelectAll != null) {
      if (_onSelectAll is void Function(List<T>)) {
        (_onSelectAll as void Function(List<T>))(items);
      } else if (_onSelectAll is void Function()) {
        (_onSelectAll as void Function())();
      }
    }
    notifyListeners();
  }

  void clearAll() {
    _selectedItems.clear();
    _onClearAll?.call();
    notifyListeners();
  }

  /// Alias for [clearAll].
  void clear() => clearAll();

  /// Clears current search filter query string.
  void clearSearch() {
    setSearchQuery('');
  }

  /// Triggers refresh / reload of async or loader dataset.
  void refresh() {
    _onRefresh?.call();
  }

  /// Alias for [refresh].
  void reload() => refresh();

  /// Programmatically focuses search field in popup.
  void focusSearch() {
    _onFocusSearch?.call();
  }

  /// Programmatically blurs search field.
  void blurSearch() {
    _onBlurSearch?.call();
  }

  void setSelection(List<T> items) {
    _selectedItems.clear();
    _selectedItems.addAll(items);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateState({
    List<T>? items,
    List<T>? selectedItems,
    String? searchQuery,
    bool? isLoading,
    String? error,
    bool? hasMore,
    bool? isOpen,
  }) {
    if (isOpen != null) {
      _isOpen = isOpen;
    }
    if (selectedItems != null) {
      _selectedItems.clear();
      _selectedItems.addAll(selectedItems);
    }
    if (searchQuery != null) {
      _searchQuery = searchQuery;
    }
    if (hasMore != null) {
      _hasMore = hasMore;
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_onLoadMore != null) {
      await _onLoadMore!.call();
    }
  }
}
