import 'package:flutter/material.dart';
import '../enums/dropdown_presentation.dart';

/// Configuration options for dropdown popup layout and presentation.
class SmartDropdownPopupConfig {
  final DropdownPresentation presentation;
  final double maxHeight;
  final double? width;
  final double elevation;
  final String? mobileTitle;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final double mobileBreakpoint;
  final double offset;

  const SmartDropdownPopupConfig({
    this.presentation = DropdownPresentation.popup,
    this.maxHeight = 350.0,
    this.width,
    this.elevation = 4.0,
    this.mobileTitle,
    this.borderRadius,
    this.backgroundColor,
    this.boxShadow,
    this.padding,
    this.mobileBreakpoint = 600.0,
    this.offset = 4.0,
  });

  SmartDropdownPopupConfig copyWith({
    DropdownPresentation? presentation,
    double? maxHeight,
    double? width,
    double? elevation,
    String? mobileTitle,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    double? mobileBreakpoint,
    double? offset,
  }) {
    return SmartDropdownPopupConfig(
      presentation: presentation ?? this.presentation,
      maxHeight: maxHeight ?? this.maxHeight,
      width: width ?? this.width,
      elevation: elevation ?? this.elevation,
      mobileTitle: mobileTitle ?? this.mobileTitle,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      boxShadow: boxShadow ?? this.boxShadow,
      padding: padding ?? this.padding,
      mobileBreakpoint: mobileBreakpoint ?? this.mobileBreakpoint,
      offset: offset ?? this.offset,
    );
  }
}
