import '../storage/recent_items_storage.dart';

/// Configuration options for displaying recent and popular items.
class SmartDropdownRecentConfig<T> {
  final bool enabled;
  final List<T>? recentItems;
  final List<T>? popularItems;
  final String recentTitle;
  final String popularTitle;
  final bool showRecent;
  final bool showPopular;
  final RecentItemsStorage<T>? storage;

  const SmartDropdownRecentConfig({
    this.enabled = false,
    this.recentItems,
    this.popularItems,
    this.recentTitle = 'Recent',
    this.popularTitle = 'Popular',
    this.showRecent = true,
    this.showPopular = true,
    this.storage,
  });
}
