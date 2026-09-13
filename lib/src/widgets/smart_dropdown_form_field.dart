import 'package:flutter/material.dart';
import '../config/smart_dropdown_config.dart';
import '../config/smart_dropdown_selection_config.dart';
import '../enums/selection_mode.dart';
import 'smart_search_dropdown.dart';

/// FormField wrapper for [SmartSearchDropdown] enabling Flutter [Form] validation and submission.
class SmartSearchDropdownFormField<T> extends FormField<dynamic> {
  SmartSearchDropdownFormField({
    super.key,
    List<T>? items,
    T? initialValue,
    List<T>? initialMultiValue,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
    ValueChanged<T?>? onChanged,
    ValueChanged<List<T>>? onMultiChanged,
    Future<List<T>> Function(String query)? asyncSearch,
    Future<List<T>> Function(String query, int page)? asyncPaginatedSearch,
    dynamic Function(T item)? itemIdExtractor,
    String Function(T item)? itemLabelBuilder,
    String? Function(T item)? itemSubtitleBuilder,
    Widget? Function(T item)? itemIconBuilder,
    Widget? Function(T item)? itemAvatarBuilder,
    Widget? Function(T item)? itemStatusBuilder,
    String Function(T item)? groupBy,
    SmartDropdownConfig<T>? config,
    SmartDropdownSelectionConfig? selectionConfig,
    String hintText = 'Select Option',
  }) : super(
          initialValue: (selectionConfig?.mode == SelectionMode.multiple)
              ? initialMultiValue
              : initialValue,
          builder: (FormFieldState<dynamic> state) {
            final isMulti = selectionConfig?.mode == SelectionMode.multiple;

            return SmartSearchDropdown<T>(
              items: items,
              value: !isMulti ? state.value as T? : null,
              selectedItems: isMulti ? (state.value as List<T>?) : null,
              onChanged: (val) {
                state.didChange(val);
                onChanged?.call(val);
              },
              onMultiChanged: (vals) {
                state.didChange(vals);
                onMultiChanged?.call(vals);
              },
              asyncSearch: asyncSearch,
              asyncPaginatedSearch: asyncPaginatedSearch,
              itemIdExtractor: itemIdExtractor,
              itemLabelBuilder: itemLabelBuilder,
              itemSubtitleBuilder: itemSubtitleBuilder,
              itemIconBuilder: itemIconBuilder,
              itemAvatarBuilder: itemAvatarBuilder,
              itemStatusBuilder: itemStatusBuilder,
              groupBy: groupBy,
              config: config,
              selection: selectionConfig,
              hintText: hintText,
              enabled: state.widget.enabled,
              errorText: state.errorText,
            );
          },
        );
}
