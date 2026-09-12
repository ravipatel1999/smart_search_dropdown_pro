import 'package:flutter/material.dart';
import '../config/smart_dropdown_selection_config.dart';
import '../theme/smart_dropdown_theme.dart';
import '../theme/smart_dropdown_tokens.dart';
import 'smart_dropdown_multi_select.dart';

/// The trigger box widget displayed in normal layout when dropdown is closed or focused.
class SmartDropdownTrigger<T> extends StatelessWidget {
  final T? selectedItem;
  final List<T> selectedItems;
  final String hintText;
  final bool isOpen;
  final bool enabled;
  final String? errorText;
  final SmartDropdownSelectionConfig selectionConfig;
  final String Function(T item) labelBuilder;
  final Widget? Function(T item)? iconBuilder;
  final Widget? Function(T item)? avatarBuilder;
  final Widget Function(BuildContext context, T item)? selectedItemBuilder;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final ValueChanged<T>? onRemoveChip;
  final FocusNode? focusNode;

  const SmartDropdownTrigger({
    super.key,
    this.selectedItem,
    required this.selectedItems,
    required this.hintText,
    required this.isOpen,
    this.enabled = true,
    this.errorText,
    required this.selectionConfig,
    required this.labelBuilder,
    this.iconBuilder,
    this.avatarBuilder,
    this.selectedItemBuilder,
    required this.onTap,
    this.onClear,
    this.onRemoveChip,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = SmartSearchDropdownTheme.of(context);
    final theme = Theme.of(context);
    final effectivePrimary = themeData.getEffectivePrimaryColor(context);

    final bool isMulti = selectionConfig.isMulti;
    final bool hasSelection = isMulti ? selectedItems.isNotEmpty : selectedItem != null;
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    Color borderColor;
    if (!enabled) {
      borderColor = theme.disabledColor.withValues(alpha: 0.3);
    } else if (hasError) {
      borderColor = themeData.errorColor ?? theme.colorScheme.error;
    } else if (isOpen) {
      borderColor = effectivePrimary;
    } else {
      borderColor = theme.colorScheme.outline;
    }

    final decoration = BoxDecoration(
      color: !enabled
          ? (themeData.disabledColor?.withValues(alpha: 0.12) ??
              theme.disabledColor.withValues(alpha: 0.08))
          : (themeData.surfaceColor ?? theme.colorScheme.surface),
      borderRadius: themeData.getEffectiveBorderRadius(),
      border: Border.all(
        color: borderColor,
        width: (isOpen || hasError) ? 1.5 : 1.0,
      ),
      boxShadow: isOpen && enabled
          ? [
              BoxShadow(
                color: effectivePrimary.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );

    Widget contentWidget;
    if (!hasSelection) {
      contentWidget = Text(
        hintText,
        style: themeData.hintStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else if (isMulti) {
      contentWidget = SmartDropdownSelectedChips<T>(
        selectedItems: selectedItems,
        labelBuilder: labelBuilder,
        onRemove: selectionConfig.allowChipRemoval ? onRemoveChip : null,
        enabled: enabled,
      );
    } else {
      final item = selectedItem as T;
      if (selectedItemBuilder != null) {
        contentWidget = selectedItemBuilder!(context, item);
      } else {
        final icon = iconBuilder?.call(item);
        final avatar = avatarBuilder?.call(item);
        final label = labelBuilder(item);

        contentWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatar != null) ...[
              avatar,
              const SizedBox(width: SmartDropdownTokens.spaceS),
            ] else if (icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  size: SmartDropdownTokens.iconSize,
                  color: enabled ? effectivePrimary : theme.disabledColor,
                ),
                child: icon,
              ),
              const SizedBox(width: SmartDropdownTokens.spaceS),
            ],
            Expanded(
              child: Text(
                label,
                style: (themeData.labelStyle ?? theme.textTheme.bodyMedium)?.copyWith(
                  color: enabled ? theme.colorScheme.onSurface : theme.disabledColor,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          enabled: enabled,
          label: hintText,
          child: InkWell(
            key: const Key('trigger_field'),
            onTap: enabled ? onTap : null,
            focusNode: focusNode,
            borderRadius: themeData.getEffectiveBorderRadius(),
            child: AnimatedContainer(
              duration: SmartDropdownTokens.durationFast,
              constraints: const BoxConstraints(
                minHeight: SmartDropdownTokens.minTouchTarget,
              ),
              padding: themeData.contentPadding ?? SmartDropdownTokens.defaultContentPadding,
              decoration: decoration,
              child: Row(
                children: [
                  Expanded(child: contentWidget),
                  if (hasSelection && onClear != null && enabled) ...[
                    const SizedBox(width: SmartDropdownTokens.spaceXS),
                    GestureDetector(
                      onTap: onClear,
                      child: Icon(
                        Icons.close_rounded,
                        size: SmartDropdownTokens.iconSize,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(width: SmartDropdownTokens.spaceXS),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0.0,
                    duration: SmartDropdownTokens.durationFast,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: SmartDropdownTokens.iconSize + 4,
                      color: enabled
                          ? (isOpen ? effectivePrimary : theme.colorScheme.onSurfaceVariant)
                          : theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: themeData.errorColor ?? theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
