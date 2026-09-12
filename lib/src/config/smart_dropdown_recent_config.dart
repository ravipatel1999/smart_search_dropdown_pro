import 'package:flutter/material.dart';
import '../storage/recent_items_storage.dart';

/// Configuration for displaying Recent and Popular sections in dropdown.
@immutable
class SmartDropdownRecentConfig<T> {
  /// Whether recent/popular section functionality is enabled.
  final bool enabled;

  /// Direct list of recent items.
  final List<T>? recentItems;

  /// Direct list of popular items.
  final List<T>? popularItems;

  /// Async getter function for recent items.
  final Future<List<T>> Function()? getRecentItems;

  /// Async getter function for popular items.
  final Future<List<T>> Function()? getPopularItems;

  /// Section header title for recent items.
  final String recentTitle;

  /// Section header title for popular items.
  final String popularTitle;

  /// Optional storage interface for persisting recent items.
  final RecentItemsStorage<T>? storage;

  const SmartDropdownRecentConfig({
    this.enabled = false,
    this.recentItems,
    this.popularItems,
    this.getRecentItems,
    this.getPopularItems,
    this.recentTitle = 'Recent Facilities',
    this.popularTitle = 'Popular Facilities',
    this.storage,
  });

  SmartDropdownRecentConfig<T> copyWith({
    bool? enabled,
    List<T>? recentItems,
    List<T>? popularItems,
    Future<List<T>> Function()? getRecentItems,
    Future<List<T>> Function()? getPopularItems,
    String? recentTitle,
    String? popularTitle,
    RecentItemsStorage<T>? storage,
  }) {
    return SmartDropdownRecentConfig<T>(
      enabled: enabled ?? this.enabled,
      recentItems: recentItems ?? this.recentItems,
      popularItems: popularItems ?? this.popularItems,
      getRecentItems: getRecentItems ?? this.getRecentItems,
      getPopularItems: getPopularItems ?? this.getPopularItems,
      recentTitle: recentTitle ?? this.recentTitle,
      popularTitle: popularTitle ?? this.popularTitle,
      storage: storage ?? this.storage,
    );
  }
}
