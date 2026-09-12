/// Abstract contract for persisting recent item selections.
abstract class RecentItemsStorage<T> {
  /// Save an item to recent history.
  Future<void> addRecent(T item);

  /// Get the list of recent items.
  Future<List<T>> getRecents();

  /// Clear all recent items.
  Future<void> clear();
}

/// Default in-memory implementation of [RecentItemsStorage].
class InMemoryRecentItemsStorage<T> implements RecentItemsStorage<T> {
  final int maxItems;
  final List<T> _items = [];

  InMemoryRecentItemsStorage({this.maxItems = 5});

  @override
  Future<void> addRecent(T item) async {
    _items.remove(item);
    _items.insert(0, item);
    if (_items.length > maxItems) {
      _items.removeLast();
    }
  }

  @override
  Future<List<T>> getRecents() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<void> clear() async {
    _items.clear();
  }
}
