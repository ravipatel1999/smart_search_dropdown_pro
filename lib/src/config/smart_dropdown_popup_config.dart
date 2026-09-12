import 'package:flutter/material.dart';
import '../enums/dropdown_presentation.dart';
import '../theme/smart_dropdown_tokens.dart';

/// Configuration for the dropdown overlay container positioning and style.
@immutable
class SmartDropdownPopupConfig {
  /// Preferred presentation mode (popup, bottomSheet, dialog, adaptive, menu).
  final DropdownPresentation presentation;

  /// Maximum height constraint for popup overlay.
  final double maxHeight;

  /// Width of popup overlay. If null, matches trigger field width.
  final double? width;

  /// Elevation shadow depth of popup card.
  final double elevation;

  /// Border radius of popup container.
  final BorderRadius? borderRadius;

  /// Vertical offset gap between trigger field and popup overlay.
  final double offset;

  /// Barrier backdrop color for modal presentations.
  final Color? barrierColor;

  /// Width breakpoint under which [DropdownPresentation.adaptive] switches to bottomSheet.
  final double mobileBreakpoint;

  /// Title header displayed when presented as bottom sheet or dialog on mobile.
  final String? mobileTitle;

  const SmartDropdownPopupConfig({
    this.presentation = DropdownPresentation.adaptive,
    this.maxHeight = SmartDropdownTokens.defaultMaxPopupHeight,
    this.width,
    this.elevation = SmartDropdownTokens.defaultElevation,
    this.borderRadius,
    this.offset = 4.0,
    this.barrierColor,
    this.mobileBreakpoint = SmartDropdownTokens.adaptiveMobileThreshold,
    this.mobileTitle,
  });

  SmartDropdownPopupConfig copyWith({
    DropdownPresentation? presentation,
    double? maxHeight,
    double? width,
    double? elevation,
    BorderRadius? borderRadius,
    double? offset,
    Color? barrierColor,
    double? mobileBreakpoint,
    String? mobileTitle,
  }) {
    return SmartDropdownPopupConfig(
      presentation: presentation ?? this.presentation,
      maxHeight: maxHeight ?? this.maxHeight,
      width: width ?? this.width,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      offset: offset ?? this.offset,
      barrierColor: barrierColor ?? this.barrierColor,
      mobileBreakpoint: mobileBreakpoint ?? this.mobileBreakpoint,
      mobileTitle: mobileTitle ?? this.mobileTitle,
    );
  }
}
