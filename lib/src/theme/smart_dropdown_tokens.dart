import 'package:flutter/material.dart';

/// Design tokens used across the SmartSearchDropdown system.
abstract class SmartDropdownTokens {
  // Spacings
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 12.0;
  static const double spaceL = 16.0;
  static const double spaceXL = 20.0;

  // Radii
  static const double radiusS = 6.0;
  static const double radiusM = 10.0;
  static const double radiusL = 14.0;
  static const double radiusXL = 20.0;

  // Sizes
  static const double minTouchTarget = 44.0;
  static const double defaultItemHeight = 48.0;
  static const double iconSize = 20.0;
  static const double avatarSize = 32.0;
  static const double searchBarHeight = 44.0;
  static const double chipHeight = 32.0;

  // Popup defaults
  static const double defaultMaxPopupHeight = 350.0;
  static const double adaptiveMobileThreshold = 600.0;
  static const double defaultElevation = 6.0;

  // Animation durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration searchDebounce = Duration(milliseconds: 300);

  // Default padding
  static const EdgeInsets defaultContentPadding = EdgeInsets.symmetric(
    horizontal: spaceL,
    vertical: spaceM,
  );

  static const EdgeInsets defaultItemPadding = EdgeInsets.symmetric(
    horizontal: spaceL,
    vertical: spaceS,
  );
}
