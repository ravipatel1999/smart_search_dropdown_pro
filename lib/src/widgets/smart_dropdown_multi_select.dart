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

  const SmartDropdownSelectedChips({
    super.key,
    required this.selectedItems,
    required this.labelBuilder,
    this.onRemove,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeData = SmartSearchDropdownTheme.of(context);
    final effectivePrimary = themeData.getEffectivePrimaryColor(context);

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: selectedItems.map((item) {
        return InputChip(
          label: Text(
            labelBuilder(item),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: effectivePrimary.withValues(alpha: 0.12),
          deleteIcon: enabled && onRemove != null
              ? Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : null,
          onDeleted: enabled && onRemove != null ? () => onRemove!(item) : null,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SmartDropdownTokens.radiusS),
            side: BorderSide(
              color: effectivePrimary.withValues(alpha: 0.3),
            ),
          ),
        );
      }).toList(),
    );
  }
}
