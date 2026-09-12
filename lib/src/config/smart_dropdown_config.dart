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

  SmartDropdownConfig<T> copyWith({
    SmartDropdownSearchConfig? search,
    SmartDropdownSelectionConfig? selection,
    SmartDropdownPopupConfig? popup,
    SmartDropdownFilterConfig<T>? filter,
    SmartDropdownPaginationConfig<T>? pagination,
    SmartDropdownCreateOptionConfig<T>? createOption,
    SmartDropdownRecentConfig<T>? recent,
  }) {
    return SmartDropdownConfig<T>(
      search: search ?? this.search,
      selection: selection ?? this.selection,
      popup: popup ?? this.popup,
      filter: filter ?? this.filter,
      pagination: pagination ?? this.pagination,
      createOption: createOption ?? this.createOption,
      recent: recent ?? this.recent,
    );
  }
}
