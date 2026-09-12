import 'package:flutter/material.dart';

/// Configuration for async pagination / infinite scroll.
@immutable
class SmartDropdownPaginationConfig<T> {
  /// Whether pagination / infinite loading is enabled.
  final bool enabled;

  /// Callback to fetch next page of items given page index (1-based or 0-based).
  final Future<List<T>> Function(int page)? onLoadMore;

  /// Distance threshold in pixels from scroll end to trigger loading next page.
  final double scrollThreshold;

  /// Page size requested per fetch.
  final int pageSize;

  /// Custom loading footer widget rendered at bottom of list during pagination fetch.
  final WidgetBuilder? loadingFooterBuilder;

  const SmartDropdownPaginationConfig({
    this.enabled = false,
    this.onLoadMore,
    this.scrollThreshold = 100.0,
    this.pageSize = 20,
    this.loadingFooterBuilder,
  });

  SmartDropdownPaginationConfig<T> copyWith({
    bool? enabled,
    Future<List<T>> Function(int page)? onLoadMore,
    double? scrollThreshold,
    int? pageSize,
    WidgetBuilder? loadingFooterBuilder,
  }) {
    return SmartDropdownPaginationConfig<T>(
      enabled: enabled ?? this.enabled,
      onLoadMore: onLoadMore ?? this.onLoadMore,
      scrollThreshold: scrollThreshold ?? this.scrollThreshold,
      pageSize: pageSize ?? this.pageSize,
      loadingFooterBuilder: loadingFooterBuilder ?? this.loadingFooterBuilder,
    );
  }
}
