import 'package:flutter/material.dart';

/// Result object describing positioning metrics for dropdown popup overlay.
class DropdownPositionResult {
  final Offset offset;
  final double width;
  final double maxHeight;
  final bool openAbove;

  const DropdownPositionResult({
    required this.offset,
    required this.width,
    required this.maxHeight,
    required this.openAbove,
  });
}

/// Helper utility to calculate optimal dropdown overlay position and height constraint.
abstract class DropdownPositionCalculator {
  static DropdownPositionResult calculate({
    required BuildContext context,
    required RenderBox targetRenderBox,
    required double preferredMaxHeight,
    required double verticalOffset,
    double? customWidth,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final targetSize = targetRenderBox.size;
    final targetPosition = targetRenderBox.localToGlobal(Offset.zero);

    final spaceBelow = screenSize.height -
        (targetPosition.dy + targetSize.height) -
        padding.bottom -
        verticalOffset -
        16.0;

    final spaceAbove = targetPosition.dy - padding.top - verticalOffset - 16.0;

    final openAbove =
        spaceBelow < preferredMaxHeight && spaceAbove > spaceBelow;

    final double availableHeight = openAbove ? spaceAbove : spaceBelow;
    final double effectiveMaxHeight = availableHeight < preferredMaxHeight
        ? availableHeight
        : preferredMaxHeight;

    final double width = customWidth ?? targetSize.width;

    final double dx = targetPosition.dx;
    final double dy = openAbove
        ? (targetPosition.dy - effectiveMaxHeight - verticalOffset)
        : (targetPosition.dy + targetSize.height + verticalOffset);

    return DropdownPositionResult(
      offset: Offset(dx, dy),
      width: width,
      maxHeight: effectiveMaxHeight > 80.0 ? effectiveMaxHeight : 80.0,
      openAbove: openAbove,
    );
  }
}
