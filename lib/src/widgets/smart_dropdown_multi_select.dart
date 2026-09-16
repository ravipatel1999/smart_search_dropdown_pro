import 'package:flutter/material.dart';
import '../config/smart_dropdown_selection_config.dart';
import '../theme/smart_dropdown_theme.dart';
import '../theme/smart_dropdown_tokens.dart';

/// Top header bar inside multi-select dropdown popups displaying Select All & Clear All options.
class SmartDropdownMultiSelectHeader extends StatelessWidget {
  final SmartDropdownSelectionConfig config;
  final bool allSelected;
  final bool someSelected;
  final VoidCallback onToggleSelectAll;
  final VoidCallback onClearAll;

  const SmartDropdownMultiSelectHeader({
    super.key,
    required this.config,
    required this.allSelected,
    required this.someSelected,
    required this.onToggleSelectAll,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = SmartSearchDropdownTheme.of(context);
    final theme = Theme.of(context);
    final effectivePrimary = themeData.getEffectivePrimaryColor(context);

    bool? checkState;
    if (allSelected) {
      checkState = true;
    } else if (someSelected) {
      checkState = null; // Tri-state indeterminate
    } else {
      checkState = false;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SmartDropdownTokens.spaceL,
        vertical: SmartDropdownTokens.spaceS,
      ),
      decoration: BoxDecoration(
        color: themeData.surfaceColor ??
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        border: Border(
          bottom: BorderSide(
            color: themeData.dividerColor ?? theme.dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (config.showSelectAll)
            InkWell(
              onTap: onToggleSelectAll,
              borderRadius: BorderRadius.circular(SmartDropdownTokens.radiusS),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: checkState,
                      tristate: true,
                      onChanged: (_) => onToggleSelectAll(),
                      activeColor: effectivePrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      config.selectAllText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          if (config.showClearAll)
            TextButton(
              onPressed: onClearAll,
              style: TextButton.styleFrom(
                foregroundColor: effectivePrimary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(config.clearAllText),
            ),
        ],
      ),
    );
  }
}

/// Selected item chip renderer for multi-select field trigger display.
class SmartDropdownSelectedChips<T> extends StatelessWidget {
  final List<T> selectedItems;
  final String Function(T item) labelBuilder;
  final ValueChanged<T>? onRemove;
  final bool enabled;
  final SmartDropdownSelectionConfig? selectionConfig;

  const SmartDropdownSelectedChips({
    super.key,
    required this.selectedItems,
    required this.labelBuilder,
    this.onRemove,
    this.enabled = true,
    this.selectionConfig,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeData = SmartSearchDropdownTheme.of(context);
    final effectivePrimary = themeData.getEffectivePrimaryColor(context);
    final config = selectionConfig;

    final maxVisible = config?.maxVisibleChips;
    final visibleItems = (maxVisible != null && maxVisible < selectedItems.length)
        ? selectedItems.sublist(0, maxVisible)
        : selectedItems;
    final overflowCount = selectedItems.length - visibleItems.length;

    final spacing = config?.chipSpacing ?? 6.0;
    final runSpacing = config?.chipRunSpacing ?? 6.0;

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...visibleItems.map((item) {
          final VoidCallback? removeCallback =
              enabled && onRemove != null ? () => onRemove!(item) : null;

          if (config?.chipBuilder != null) {
            return config!.chipBuilder!(context, item, removeCallback);
          }

          final labelTextStr = config?.chipLabelBuilder?.call(item) ?? labelBuilder(item);
          final avatarWidget = config?.chipAvatarBuilder?.call(item);
          final deleteIconWidget = config?.chipDeleteIcon ??
              Icon(
                Icons.close_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              );

          return InputChip(
            avatar: avatarWidget,
            label: Text(
              labelTextStr,
              style: config?.chipTextStyle ??
                  theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            backgroundColor: config?.chipBackgroundColor ?? effectivePrimary.withValues(alpha: 0.12),
            deleteIcon: enabled && onRemove != null ? deleteIconWidget : null,
            onDeleted: removeCallback,
            padding: config?.chipPadding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SmartDropdownTokens.radiusS),
              side: config?.chipBorder ??
                  BorderSide(
                    color: effectivePrimary.withValues(alpha: 0.3),
                  ),
            ),
          );
        }),
        if (overflowCount > 0)
          if (config?.overflowChipBuilder != null)
            config!.overflowChipBuilder!(context, overflowCount)
          else
            Chip(
              label: Text(
                '+$overflowCount',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: effectivePrimary,
                ),
              ),
              backgroundColor: effectivePrimary.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
      ],
    );
  }
}
