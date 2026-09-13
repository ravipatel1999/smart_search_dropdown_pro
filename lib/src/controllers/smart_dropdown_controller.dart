import 'package:flutter/foundation.dart';

/// Controller for managing state and programmatically controlling [SmartSearchDropdown].
class SmartDropdownController<T> extends ChangeNotifier {
  final List<T> _selectedItems = [];
  bool _isOpen = false;
  String _searchQuery = '';
  bool _hasMore = true;
  bool _isLoadingInitial = false;
  bool _isLoadingMore = false;
  String? _error;
  String? _paginationError;
  int _currentPage = 1;
  int _searchGeneration = 0;

  VoidCallback? _onOpen;
  VoidCallback? _onClose;
  VoidCallback? _onToggle;
  ValueChanged<T>? _onSelect;
  ValueChanged<T>? _onDeselect;
  Function? _onSelectAll;
  VoidCallback? _onClearAll;
  Function? _onLoadMore;
  VoidCallback? _onRetry;
  VoidCallback? _onRetryPagination;
  VoidCallback? _onRefresh;

  SmartDropdownController({List<T>? initialSelection}) {
    if (initialSelection != null) {
      _selectedItems.addAll(initialSelection);
    }
  }

  bool get isOpen => _isOpen;
  String get searchQuery => _searchQuery;
  bool get hasMore => _hasMore;
  bool get isLoadingInitial => _isLoadingInitial;
  bool get isLoadingMore => _isLoadingMore;
  bool get isLoading => _isLoadingInitial || _isLoadingMore;
  String? get error => _error;
  String? get paginationError => _paginationError;
  int get currentPage => _currentPage;
  int get searchGeneration => _searchGeneration;
  T? get selectedItem => _selectedItems.isNotEmpty ? _selectedItems.first : null;
  List<T> get selectedItems => List.unmodifiable(_selectedItems);

  void attachCallbacks({
    VoidCallback? onOpen,
    VoidCallback? onClose,
    VoidCallback? onToggle,
    ValueChanged<T>? onSelect,
    ValueChanged<T>? onDeselect,
    Function? onSelectAll,
    VoidCallback? onClearAll,
    Function? onLoadMore,
    VoidCallback? onRetry,
    VoidCallback? onRetryPagination,
    VoidCallback? onRefresh,
  }) {
    _onOpen = onOpen;
    _onClose = onClose;
    _onToggle = onToggle;
    _onSelect = onSelect;
    _onDeselect = onDeselect;
    _onSelectAll = onSelectAll;
    _onClearAll = onClearAll;
    _onLoadMore = onLoadMore;
    _onRetry = onRetry;
    _onRetryPagination = onRetryPagination;
    _onRefresh = onRefresh;
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
    _onRetry = null;
    _onRetryPagination = null;
    _onRefresh = null;
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
    bool? isLoadingInitial,
    bool? isLoadingMore,
    String? error,
    String? paginationError,
    bool? hasMore,
    int? currentPage,
    int? searchGeneration,
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
    if (isLoadingInitial != null) {
      _isLoadingInitial = isLoadingInitial;
    } else if (isLoading != null && isLoadingMore == null) {
      _isLoadingInitial = isLoading;
    }
    if (isLoadingMore != null) {
      _isLoadingMore = isLoadingMore;
    }
    if (error != null) {
      _error = error.isEmpty ? null : error;
    } else if (error == null && isLoading == true) {
      _error = null;
    }
    if (paginationError != null) {
      _paginationError = paginationError.isEmpty ? null : paginationError;
    }
    if (hasMore != null) {
      _hasMore = hasMore;
    }
    if (currentPage != null) {
      _currentPage = currentPage;
    }
    if (searchGeneration != null) {
      _searchGeneration = searchGeneration;
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_onLoadMore != null) {
      await _onLoadMore!.call();
    }
  }

  Future<void> retry() async {
    _onRetry?.call();
  }

  Future<void> retryPagination() async {
    _onRetryPagination?.call();
  }

  Future<void> refresh() async {
    _onRefresh?.call();
  }
}
