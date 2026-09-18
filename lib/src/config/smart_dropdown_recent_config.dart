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

  SmartDropdownRecentConfig<T> copyWith({
    bool? enabled,
    List<T>? recentItems,
    List<T>? popularItems,
    String? recentTitle,
    String? popularTitle,
    bool? showRecent,
    bool? showPopular,
    RecentItemsStorage<T>? storage,
  }) {
    return SmartDropdownRecentConfig<T>(
      enabled: enabled ?? this.enabled,
      recentItems: recentItems ?? this.recentItems,
      popularItems: popularItems ?? this.popularItems,
      recentTitle: recentTitle ?? this.recentTitle,
      popularTitle: popularTitle ?? this.popularTitle,
      showRecent: showRecent ?? this.showRecent,
      showPopular: showPopular ?? this.showPopular,
      storage: storage ?? this.storage,
    );
  }
}
