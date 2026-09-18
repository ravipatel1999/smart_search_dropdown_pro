import 'package:flutter/material.dart';
import '../config/smart_dropdown_config.dart';
import '../controllers/smart_dropdown_controller.dart';
import '../models/dropdown_group.dart';
import '../models/dropdown_item_state.dart';
import '../models/recent_popular_item.dart';
import '../theme/smart_dropdown_theme.dart';
import '../theme/smart_dropdown_tokens.dart';
import '../utilities/search_utils.dart';
import 'smart_dropdown_item_tile.dart';
import 'smart_dropdown_multi_select.dart';
import 'smart_dropdown_search_field.dart';

/// Popup overlay card body displaying filters, search field, group headers, and item list.
class SmartDropdownPopup<T> extends StatefulWidget {
  final SmartDropdownConfig<T> config;
  final List<T> items;
  final List<DropdownGroup<T>>? groupedItems;
  final List<RecentPopularItem<T>>? recentPopularItems;
  final List<T> selectedItems;
  final SmartDropdownController<T> controller;

  final String Function(T item) labelBuilder;
  final String? Function(T item)? subtitleBuilder;
  final Widget? Function(T item)? iconBuilder;
  final Widget? Function(T item)? avatarBuilder;
  final Widget? Function(T item)? statusBuilder;
  final Widget? Function(T item)? trailingBuilder;
  final Widget Function(
      BuildContext context, T item, SmartDropdownItemState state)? itemBuilder;
  final Widget Function(BuildContext context, String groupName)?
      groupHeaderBuilder;

  final WidgetBuilder? emptyBuilder;
  final Widget Function(BuildContext context, String error)? errorBuilder;
  final WidgetBuilder? loadingBuilder;

  final ValueChanged<T> onItemTap;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onToggleSelectAll;
  final VoidCallback onClearAll;
  final ValueChanged<String>? onCreateOption;

  final bool isLoading;
  final String? error;
  final bool isMobileModal;
  final VoidCallback? onCloseModal;
  final Widget Function(BuildContext context, ValueChanged<String> onChanged)?
      searchFieldBuilder;
  final Widget? Function(T item)? itemLeadingBuilder;
  final bool Function(T item)? isItemDisabled;
  final bool? showScrollbar;
  final bool? showCheckbox;
  final bool? showStatus;

  const SmartDropdownPopup({
    super.key,
    required this.config,
    required this.items,
    this.groupedItems,
    this.recentPopularItems,
    required this.selectedItems,
    required this.controller,
    required this.labelBuilder,
    this.subtitleBuilder,
    this.iconBuilder,
    this.avatarBuilder,
    this.statusBuilder,
    this.trailingBuilder,
    this.itemBuilder,
    this.groupHeaderBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.searchFieldBuilder,
    this.itemLeadingBuilder,
    this.isItemDisabled,
    this.showScrollbar,
    this.showCheckbox,
    this.showStatus,
    required this.onItemTap,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onToggleSelectAll,
    required this.onClearAll,
    this.onCreateOption,
    this.isLoading = false,
    this.error,
    this.isMobileModal = false,
    this.onCloseModal,
  });

  @override
  State<SmartDropdownPopup<T>> createState() => _SmartDropdownPopupState<T>();
}

class _SmartDropdownPopupState<T> extends State<SmartDropdownPopup<T>> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    if (widget.config.pagination.enabled) {
      _scrollController.addListener(_onScroll);
    }
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_isFetchingMore) return;
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final threshold = widget.config.pagination.scrollThreshold;

    if (maxScroll - currentScroll <= threshold) {
      if (widget.controller.hasMore) {
        setState(() => _isFetchingMore = true);
        await widget.controller.loadMore();
        if (mounted) {
          setState(() => _isFetchingMore = false);
        }
      }
    }
  }

  List<T> get _effectiveFilteredItems {
    final query = widget.controller.searchQuery;
    final searchConfig = widget.config.search;

    if (widget.items.isEmpty) return [];
    if (query.isEmpty || query.length < searchConfig.minChars) {
      return widget.items;
    }

    return widget.items.where((item) {
      if (searchConfig.customSearch != null) {
        return searchConfig.customSearch!(item, query);
      }
      return SearchUtils.matches(
        label: widget.labelBuilder(item),
        query: query,
        searchMode: searchConfig.searchMode,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = SmartSearchDropdownTheme.of(context);
    final theme = Theme.of(context);
    final effectivePrimary = themeData.getEffectivePrimaryColor(context);

    final bool isMulti = widget.config.selection.isMulti;
    final displayItems = _effectiveFilteredItems;

    Widget body;
    if (widget.isLoading && widget.items.isEmpty) {
      body = widget.loadingBuilder?.call(context) ??
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: effectivePrimary,
                ),
              ),
            ),
          );
    } else if (widget.error != null && widget.error!.isNotEmpty) {
      body = widget.errorBuilder?.call(context, widget.error!) ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 36,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
    } else if (displayItems.isEmpty &&
        (widget.groupedItems == null || widget.groupedItems!.isEmpty) &&
        (widget.recentPopularItems == null ||
            widget.recentPopularItems!.isEmpty)) {
      final bool showCreateOption = widget.config.createOption.enabled &&
          widget.controller.searchQuery.isNotEmpty &&
          widget.onCreateOption != null;

      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCreateOption)
            _buildCreateOptionTile(context, widget.controller.searchQuery),
          Expanded(
            child: widget.emptyBuilder?.call(context) ??
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.find_in_page_outlined,
                          size: 44,
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No items found',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try a different search term or clear filters.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ],
      );
    } else {
      body = _buildItemList(context);
    }

    final containerDecoration = BoxDecoration(
      color: themeData.getEffectiveBackgroundColor(context),
      borderRadius: widget.isMobileModal
          ? const BorderRadius.vertical(
              top: Radius.circular(SmartDropdownTokens.radiusXL))
          : themeData.getEffectiveBorderRadius(),
      boxShadow: widget.isMobileModal
          ? null
          : [
              BoxShadow(
                color: themeData.shadowColor ??
                    Colors.black.withValues(alpha: 0.12),
                blurRadius: widget.config.popup.elevation * 2,
                offset: Offset(0, widget.config.popup.elevation),
              ),
            ],
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: widget.config.popup.maxHeight,
          maxWidth: widget.config.popup.width ?? double.infinity,
        ),
        decoration: containerDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.isMobileModal) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.config.popup.mobileTitle ?? 'Select Option',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: widget.onCloseModal ??
                          () => widget.controller.close(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
            ],
            if (widget.config.filter.enabled &&
                widget.config.filter.builder != null) ...[
              widget.config.filter.builder!(context, widget.controller),
            ],
            if (widget.config.search.enabled) ...[
              if (widget.searchFieldBuilder != null)
                widget.searchFieldBuilder!(context, widget.onSearchChanged)
              else
                SmartDropdownSearchField(
                  config: widget.config.search,
                  onChanged: widget.onSearchChanged,
                  onClear: widget.onClearSearch,
                ),
            ],
            if (isMulti &&
                (widget.config.selection.showSelectAll ||
                    widget.config.selection.showClearAll)) ...[
              SmartDropdownMultiSelectHeader(
                config: widget.config.selection,
                allSelected: widget.items.isNotEmpty &&
                    widget.selectedItems.length >= widget.items.length,
                someSelected: widget.selectedItems.isNotEmpty &&
                    widget.selectedItems.length < widget.items.length,
                onToggleSelectAll: widget.onToggleSelectAll,
                onClearAll: widget.onClearAll,
              ),
            ],
            Expanded(child: body),
            if (isMulti && widget.config.selection.showConfirmBar) ...[
              const Divider(height: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => widget.controller.close(),
                      child: Text(widget.config.selection.cancelText),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => widget.controller.close(),
                      style: FilledButton.styleFrom(
                        backgroundColor: effectivePrimary,
                      ),
                      child: Text(widget.config.selection.confirmText),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreateOptionTile(BuildContext context, String query) {
    if (widget.config.createOption.builder != null) {
      return InkWell(
        onTap: () => widget.onCreateOption?.call(query),
        child: widget.config.createOption.builder!(context, query),
      );
    }

    final theme = Theme.of(context);
    final themeData = SmartSearchDropdownTheme.of(context);
    final effectivePrimary = themeData.getEffectivePrimaryColor(context);

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: effectivePrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(SmartDropdownTokens.radiusM),
        border: Border.all(color: effectivePrimary.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        leading: Icon(Icons.add_rounded, color: effectivePrimary),
        title: Text(
          'Create "$query"',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: effectivePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => widget.onCreateOption?.call(query),
      ),
    );
  }

  Widget _buildItemList(BuildContext context) {
    final theme = Theme.of(context);
    final bool isMulti = widget.config.selection.isMulti;

    // Grouped layout
    if (widget.groupedItems != null && widget.groupedItems!.isNotEmpty) {
      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: widget.groupedItems!.length,
        itemBuilder: (context, groupIndex) {
          final group = widget.groupedItems![groupIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.groupHeaderBuilder != null)
                widget.groupHeaderBuilder!(context, group.name)
              else
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.4),
                  child: Text(
                    group.name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ...group.items.map((item) {
                final isSelected = widget.selectedItems.contains(item);
                final isDisabled = widget.isItemDisabled?.call(item) ?? false;
                final itemState = SmartDropdownItemState(
                  index: widget.items.indexOf(item),
                  isSelected: isSelected,
                  isDisabled: isDisabled,
                  searchQuery: widget.controller.searchQuery,
                );
                return SmartDropdownItemTile<T>(
                  item: item,
                  state: itemState,
                  label: widget.labelBuilder(item),
                  subtitle: widget.subtitleBuilder?.call(item),
                  icon: widget.iconBuilder?.call(item),
                  avatar: widget.avatarBuilder?.call(item),
                  status: (widget.showStatus ?? true)
                      ? widget.statusBuilder?.call(item)
                      : null,
                  trailing: widget.trailingBuilder?.call(item),
                  itemLeadingBuilder: widget.itemLeadingBuilder,
                  isMultiSelect: isMulti,
                  highlightMatches: widget.config.search.highlightMatches,
                  highlightColor: widget.config.search.highlightColor,
                  onTap: widget.onItemTap,
                  itemBuilder: widget.itemBuilder,
                );
              }),
            ],
          );
        },
      );
    }

    // Recent / Popular sections layout
    if (widget.recentPopularItems != null &&
        widget.recentPopularItems!.isNotEmpty) {
      String? currentHeader;

      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: widget.recentPopularItems!.length,
        itemBuilder: (context, index) {
          final wrapper = widget.recentPopularItems![index];
          final String headerTitle = wrapper.type == RecentPopularType.recent
              ? widget.config.recent.recentTitle
              : (wrapper.type == RecentPopularType.popular
                  ? widget.config.recent.popularTitle
                  : 'All Items');

          bool showHeader = false;
          if (currentHeader != headerTitle) {
            currentHeader = headerTitle;
            showHeader = true;
          }

          final isSelected = widget.selectedItems.contains(wrapper.item);
          final isDisabled = widget.isItemDisabled?.call(wrapper.item) ?? false;
          final itemState = SmartDropdownItemState(
            index: index,
            isSelected: isSelected,
            isDisabled: isDisabled,
            searchQuery: widget.controller.searchQuery,
          );

          Widget tileWidget = SmartDropdownItemTile<T>(
            item: wrapper.item,
            state: itemState,
            label: widget.labelBuilder(wrapper.item),
            subtitle: widget.subtitleBuilder?.call(wrapper.item),
            icon: wrapper.type == RecentPopularType.recent
                ? const Icon(Icons.history_rounded)
                : (wrapper.type == RecentPopularType.popular
                    ? const Icon(Icons.star_rounded, color: Colors.amber)
                    : widget.iconBuilder?.call(wrapper.item)),
            avatar: widget.avatarBuilder?.call(wrapper.item),
            status: (widget.showStatus ?? true)
                ? widget.statusBuilder?.call(wrapper.item)
                : null,
            trailing: widget.trailingBuilder?.call(wrapper.item),
            itemLeadingBuilder: widget.itemLeadingBuilder,
            isMultiSelect: isMulti,
            highlightMatches: widget.config.search.highlightMatches,
            highlightColor: widget.config.search.highlightColor,
            onTap: widget.onItemTap,
            itemBuilder: widget.itemBuilder,
          );

          if (showHeader) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  child: Text(
                    headerTitle,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                tileWidget,
              ],
            );
          }

          return tileWidget;
        },
      );
    }

    final displayItems = _effectiveFilteredItems;
    final bool showCreateOption = widget.config.createOption.enabled &&
        widget.controller.searchQuery.isNotEmpty &&
        widget.onCreateOption != null;

    final int totalCount = displayItems.length +
        (showCreateOption ? 1 : 0) +
        (widget.config.pagination.enabled ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: totalCount,
      itemBuilder: (context, index) {
        if (showCreateOption && index == 0) {
          return _buildCreateOptionTile(context, widget.controller.searchQuery);
        }

        final int itemIndex = showCreateOption ? index - 1 : index;

        if (itemIndex == displayItems.length &&
            widget.config.pagination.enabled) {
          if (widget.config.pagination.loadingFooterBuilder != null) {
            return widget.config.pagination.loadingFooterBuilder!(context);
          }
          return Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading more...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        final item = displayItems[itemIndex];
        final isSelected = widget.selectedItems.contains(item);
        final isDisabled = widget.isItemDisabled?.call(item) ?? false;
        final itemState = SmartDropdownItemState(
          index: itemIndex,
          isSelected: isSelected,
          isDisabled: isDisabled,
          searchQuery: widget.controller.searchQuery,
        );

        return SmartDropdownItemTile<T>(
          item: item,
          state: itemState,
          label: widget.labelBuilder(item),
          subtitle: widget.subtitleBuilder?.call(item),
          icon: widget.iconBuilder?.call(item),
          avatar: widget.avatarBuilder?.call(item),
          status: (widget.showStatus ?? true)
              ? widget.statusBuilder?.call(item)
              : null,
          trailing: widget.trailingBuilder?.call(item),
          itemLeadingBuilder: widget.itemLeadingBuilder,
          isMultiSelect: isMulti,
          highlightMatches: widget.config.search.highlightMatches,
          highlightColor: widget.config.search.highlightColor,
          onTap: widget.onItemTap,
          itemBuilder: widget.itemBuilder,
        );
      },
    );
  }
}
