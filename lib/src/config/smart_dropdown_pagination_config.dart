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
}
