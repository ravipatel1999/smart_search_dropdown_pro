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

  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final EdgeInsetsGeometry? margin;
  final Color? barrierColor;
  final bool closeOnSelect;
  final bool closeOnOutsideTap;
  final bool closeOnEscape;

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
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.margin,
    this.barrierColor,
    this.closeOnSelect = true,
    this.closeOnOutsideTap = true,
    this.closeOnEscape = true,
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
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    EdgeInsetsGeometry? margin,
    Color? barrierColor,
    bool? closeOnSelect,
    bool? closeOnOutsideTap,
    bool? closeOnEscape,
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
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      margin: margin ?? this.margin,
      barrierColor: barrierColor ?? this.barrierColor,
      closeOnSelect: closeOnSelect ?? this.closeOnSelect,
      closeOnOutsideTap: closeOnOutsideTap ?? this.closeOnOutsideTap,
      closeOnEscape: closeOnEscape ?? this.closeOnEscape,
    );
  }
}
