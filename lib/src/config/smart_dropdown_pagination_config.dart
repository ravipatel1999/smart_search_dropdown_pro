import 'package:flutter/material.dart';

/// Configuration options for dropdown pagination and lazy loading.
class SmartDropdownPaginationConfig<T> {
  /// Whether pagination is enabled.
  final bool enabled;

  /// Scroll distance threshold from the bottom to trigger loading more items.
  final double scrollThreshold;

  /// Callback to load the next page of items. Receives 1-indexed [page].
  final Future<List<T>> Function(int page)? onLoadMore;

  /// Query-aware callback to load the next page of items. Receives [page] and active [query].
  final Future<List<T>> Function(int page, String query)? onLoadMoreWithQuery;

  /// Custom builder for loading footer when pagination is actively fetching more items.
  final WidgetBuilder? loadingFooterBuilder;

  /// Custom builder for pagination error footer with retry callback.
  final Widget Function(BuildContext context, String error, VoidCallback onRetry)?
      errorFooterBuilder;

  /// Custom builder shown when all pages have loaded and [hasMore] is false.
  final WidgetBuilder? noMoreItemsBuilder;

  /// Target page size used to determine if more items remain.
  final int pageSize;

  /// Function extracting a stable, unique identifier for an item [T] to prevent duplicates across pages.
  final dynamic Function(T item)? itemIdExtractor;

  /// Whether to automatically deduplicate incoming pages against existing items.
  final bool preventDuplicates;

  const SmartDropdownPaginationConfig({
    this.enabled = false,
    this.scrollThreshold = 200.0,
    this.onLoadMore,
    this.onLoadMoreWithQuery,
    this.loadingFooterBuilder,
    this.errorFooterBuilder,
    this.noMoreItemsBuilder,
    this.pageSize = 20,
    this.itemIdExtractor,
    this.preventDuplicates = true,
  });

  SmartDropdownPaginationConfig<T> copyWith({
    bool? enabled,
    double? scrollThreshold,
    Future<List<T>> Function(int page)? onLoadMore,
    Future<List<T>> Function(int page, String query)? onLoadMoreWithQuery,
    WidgetBuilder? loadingFooterBuilder,
    Widget Function(BuildContext context, String error, VoidCallback onRetry)?
        errorFooterBuilder,
    WidgetBuilder? noMoreItemsBuilder,
    int? pageSize,
    dynamic Function(T item)? itemIdExtractor,
    bool? preventDuplicates,
  }) {
    return SmartDropdownPaginationConfig<T>(
      enabled: enabled ?? this.enabled,
      scrollThreshold: scrollThreshold ?? this.scrollThreshold,
      onLoadMore: onLoadMore ?? this.onLoadMore,
      onLoadMoreWithQuery: onLoadMoreWithQuery ?? this.onLoadMoreWithQuery,
      loadingFooterBuilder: loadingFooterBuilder ?? this.loadingFooterBuilder,
      errorFooterBuilder: errorFooterBuilder ?? this.errorFooterBuilder,
      noMoreItemsBuilder: noMoreItemsBuilder ?? this.noMoreItemsBuilder,
      pageSize: pageSize ?? this.pageSize,
      itemIdExtractor: itemIdExtractor ?? this.itemIdExtractor,
      preventDuplicates: preventDuplicates ?? this.preventDuplicates,
    );
  }
}
