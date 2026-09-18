import 'package:flutter/material.dart';
import '../config/smart_dropdown_search_config.dart';
import '../theme/smart_dropdown_theme.dart';
import '../theme/smart_dropdown_tokens.dart';

/// Search text field rendered inside the dropdown popup.
class SmartDropdownSearchField extends StatefulWidget {
  final SmartDropdownSearchConfig config;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final TextEditingController? textController;
  final FocusNode? focusNode;

  const SmartDropdownSearchField({
    super.key,
    required this.config,
    required this.onChanged,
    required this.onClear,
    this.textController,
    this.focusNode,
  });

  @override
  State<SmartDropdownSearchField> createState() =>
      _SmartDropdownSearchFieldState();
}

class _SmartDropdownSearchFieldState extends State<SmartDropdownSearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isInternalController = false;
  bool _isInternalFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.textController != null) {
      _controller = widget.textController!;
    } else {
      _controller = TextEditingController();
      _isInternalController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isInternalFocusNode = true;
    }

    if (widget.config.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNode.canRequestFocus) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    if (_isInternalFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = SmartSearchDropdownTheme.of(context);
    final theme = Theme.of(context);
    final effectivePrimary = themeData.getEffectivePrimaryColor(context);

    final defaultDecoration = InputDecoration(
      hintText: widget.config.hintText,
      hintStyle: themeData.hintStyle ??
          theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
      prefixIcon: widget.config.searchIcon ??
          Icon(
            Icons.search_rounded,
            size: SmartDropdownTokens.iconSize,
            color: theme.colorScheme.onSurfaceVariant,
          ),
      suffixIcon: _controller.text.isNotEmpty
          ? IconButton(
              icon: widget.config.clearIcon ??
                  Icon(
                    Icons.cancel_rounded,
                    size: SmartDropdownTokens.iconSize,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
              onPressed: () {
                _controller.clear();
                widget.onClear();
                setState(() {});
              },
            )
          : null,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: themeData.surfaceColor ??
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SmartDropdownTokens.radiusM),
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SmartDropdownTokens.radiusM),
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SmartDropdownTokens.radiusM),
        borderSide: BorderSide(
          color: effectivePrimary,
          width: 1.5,
        ),
      ),
    );

    final finalDecoration = widget.config.inputDecoration != null
        ? defaultDecoration.copyWith(
            hintText: widget.config.inputDecoration!.hintText,
            prefixIcon: widget.config.inputDecoration!.prefixIcon,
            suffixIcon: widget.config.inputDecoration!.suffixIcon,
          )
        : defaultDecoration;

    return Padding(
      padding: themeData.searchPadding ??
          const EdgeInsets.fromLTRB(
            SmartDropdownTokens.spaceM,
            SmartDropdownTokens.spaceM,
            SmartDropdownTokens.spaceM,
            SmartDropdownTokens.spaceS,
          ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: themeData.searchTextStyle ?? theme.textTheme.bodyMedium,
        decoration: finalDecoration,
        onChanged: (query) {
          setState(() {});
          widget.onChanged(query);
        },
      ),
    );
  }
}
