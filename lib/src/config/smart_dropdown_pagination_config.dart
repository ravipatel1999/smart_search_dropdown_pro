import 'package:flutter/material.dart';

/// Configuration options for dropdown pagination and lazy loading.
class SmartDropdownPaginationConfig<T> {
  final bool enabled;
  final double scrollThreshold;
  final Future<List<T>> Function(int page)? onLoadMore;
  final WidgetBuilder? loadingFooterBuilder;
  final int pageSize;

  const SmartDropdownPaginationConfig({
    this.enabled = false,
    this.scrollThreshold = 200.0,
    this.onLoadMore,
    this.loadingFooterBuilder,
    this.pageSize = 20,
  });

  SmartDropdownPaginationConfig<R> copyWith<R>({
    bool? enabled,
    double? scrollThreshold,
    Future<List<R>> Function(int page)? onLoadMore,
    WidgetBuilder? loadingFooterBuilder,
    int? pageSize,
  }) {
    return SmartDropdownPaginationConfig<R>(
      enabled: enabled ?? this.enabled,
      scrollThreshold: scrollThreshold ?? this.scrollThreshold,
      onLoadMore: onLoadMore ??
          (onLoadMore == null
              ? (this.onLoadMore as Future<List<R>> Function(int page)?)
              : null),
      loadingFooterBuilder: loadingFooterBuilder ?? this.loadingFooterBuilder,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
