import 'package:flutter/material.dart';
import '../models/dropdown_item_state.dart';
import '../theme/smart_dropdown_theme.dart';
import '../theme/smart_dropdown_tokens.dart';
import '../utilities/search_utils.dart';

/// Single item list tile component used inside the dropdown popup.
class SmartDropdownItemTile<T> extends StatelessWidget {
  final T item;
  final SmartDropdownItemState state;
  final String label;
  final String? subtitle;
  final Widget? icon;
  final Widget? avatar;
  final Widget? status;
  final Widget? trailing;
  final Widget? Function(T item)? itemLeadingBuilder;
  final bool isMultiSelect;
  final bool highlightMatches;
  final Color? highlightColor;
  final ValueChanged<T> onTap;
  final Widget Function(
      BuildContext context, T item, SmartDropdownItemState state)? itemBuilder;

  const SmartDropdownItemTile({
    super.key,
    required this.item,
    required this.state,
    required this.label,
    this.subtitle,
    this.icon,
    this.avatar,
    this.status,
    this.trailing,
    this.itemLeadingBuilder,
    required this.isMultiSelect,
    this.highlightMatches = false,
    this.highlightColor,
    required this.onTap,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (itemBuilder != null) {
      return InkWell(
        onTap: state.isDisabled ? null : () => onTap(item),
        child: itemBuilder!(context, item, state),
      );
    }

    final themeData = SmartSearchDropdownTheme.of(context);
    final theme = Theme.of(context);

    final effectivePrimary = themeData.getEffectivePrimaryColor(context);
    final effectiveSelectedBg = themeData.getEffectiveSelectedColor(context);

    final Color backgroundColor = state.isSelected
        ? effectiveSelectedBg
        : (state.isFocused || state.isHovered
            ? theme.hoverColor
            : Colors.transparent);

    final TextStyle baseLabelStyle = (themeData.labelStyle ??
            theme.textTheme.bodyMedium ??
            const TextStyle())
        .copyWith(
      color: state.isDisabled
          ? theme.disabledColor
          : (state.isSelected ? effectivePrimary : theme.colorScheme.onSurface),
      fontWeight: state.isSelected ? FontWeight.w600 : FontWeight.normal,
    );

    final TextStyle subtitleStyle = (themeData.subtitleStyle ??
            theme.textTheme.bodySmall ??
            const TextStyle())
        .copyWith(
      color: state.isDisabled
          ? theme.disabledColor.withValues(alpha: 0.6)
          : theme.colorScheme.onSurfaceVariant,
    );

    final customLeading = itemLeadingBuilder?.call(item);

    Widget leadingWidget;
    if (customLeading != null) {
      leadingWidget = customLeading;
    } else if (isMultiSelect) {
      leadingWidget = Checkbox(
        value: state.isSelected,
        onChanged: state.isDisabled ? null : (_) => onTap(item),
        activeColor: effectivePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      );
    } else if (avatar != null) {
      leadingWidget = avatar!;
    } else if (icon != null) {
      leadingWidget = IconTheme(
        data: IconThemeData(
          size: SmartDropdownTokens.iconSize,
          color: state.isSelected
              ? effectivePrimary
              : theme.colorScheme.onSurfaceVariant,
        ),
        child: icon!,
      );
    } else {
      leadingWidget = const SizedBox.shrink();
    }

    final hasLeading = customLeading != null ||
        isMultiSelect ||
        avatar != null ||
        icon != null;

    Widget titleWidget;
    if (highlightMatches && state.searchQuery.isNotEmpty) {
      titleWidget = SearchUtils.buildHighlightedText(
        text: label,
        query: state.searchQuery,
        baseStyle: baseLabelStyle,
        highlightColor:
            highlightColor ?? effectivePrimary.withValues(alpha: 0.25),
      );
    } else {
      titleWidget = Text(
        label,
        style: baseLabelStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    Widget? trailingWidget = trailing;
    if (trailingWidget == null && status != null) {
      trailingWidget = status;
    } else if (trailingWidget == null && !isMultiSelect && state.isSelected) {
      trailingWidget = Icon(
        Icons.check_rounded,
        size: SmartDropdownTokens.iconSize,
        color: effectivePrimary,
      );
    }

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: state.isDisabled ? null : () => onTap(item),
        hoverColor: themeData.hoverColor ?? theme.hoverColor,
        child: Padding(
          padding:
              themeData.itemPadding ?? SmartDropdownTokens.defaultItemPadding,
          child: Row(
            children: [
              if (hasLeading) ...[
                leadingWidget,
                const SizedBox(width: SmartDropdownTokens.spaceM),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    titleWidget,
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: subtitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailingWidget != null) ...[
                const SizedBox(width: SmartDropdownTokens.spaceS),
                trailingWidget,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
