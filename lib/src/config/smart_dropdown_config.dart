import 'smart_dropdown_create_option_config.dart';
import 'smart_dropdown_filter_config.dart';
import 'smart_dropdown_pagination_config.dart';
import 'smart_dropdown_popup_config.dart';
import 'smart_dropdown_recent_config.dart';
import 'smart_dropdown_search_config.dart';
import 'smart_dropdown_selection_config.dart';

/// Master configuration object aggregating all sub-configs for [SmartSearchDropdown].
class SmartDropdownConfig<T> {
  final SmartDropdownSearchConfig search;
  final SmartDropdownSelectionConfig selection;
  final SmartDropdownPopupConfig popup;
  final SmartDropdownFilterConfig<T> filter;
  final SmartDropdownPaginationConfig<T> pagination;
  final SmartDropdownCreateOptionConfig<T> createOption;
  final SmartDropdownRecentConfig<T> recent;

  const SmartDropdownConfig({
    this.search = const SmartDropdownSearchConfig(),
    this.selection = const SmartDropdownSelectionConfig(),
    this.popup = const SmartDropdownPopupConfig(),
    this.filter = const SmartDropdownFilterConfig(),
    this.pagination = const SmartDropdownPaginationConfig(),
    this.createOption = const SmartDropdownCreateOptionConfig(),
    this.recent = const SmartDropdownRecentConfig(),
  });

  SmartDropdownConfig<R> copyWith<R>({
    SmartDropdownSearchConfig? search,
    SmartDropdownSelectionConfig? selection,
    SmartDropdownPopupConfig? popup,
    SmartDropdownFilterConfig<R>? filter,
    SmartDropdownPaginationConfig<R>? pagination,
    SmartDropdownCreateOptionConfig<R>? createOption,
    SmartDropdownRecentConfig<R>? recent,
  }) {
    return SmartDropdownConfig<R>(
      search: search ?? this.search,
      selection: selection ?? this.selection,
      popup: popup ?? this.popup,
      filter: filter ??
          (this.filter is SmartDropdownFilterConfig<R>
              ? this.filter as SmartDropdownFilterConfig<R>
              : const SmartDropdownFilterConfig()),
      pagination: pagination ??
          (this.pagination is SmartDropdownPaginationConfig<R>
              ? this.pagination as SmartDropdownPaginationConfig<R>
              : const SmartDropdownPaginationConfig()),
      createOption: createOption ??
          (this.createOption is SmartDropdownCreateOptionConfig<R>
              ? this.createOption as SmartDropdownCreateOptionConfig<R>
              : const SmartDropdownCreateOptionConfig()),
      recent: recent ??
          (this.recent is SmartDropdownRecentConfig<R>
              ? this.recent as SmartDropdownRecentConfig<R>
              : const SmartDropdownRecentConfig()),
    );
  }
}
