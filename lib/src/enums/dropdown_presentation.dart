/// Defines how the dropdown popup options are presented on screen.
enum DropdownPresentation {
  /// Anchored popup menu directly below or above the target widget.
  popup,

  /// Floating contextual menu style anchored to trigger.
  menu,

  /// Bottom sheet modal sliding up from screen bottom (common on mobile).
  bottomSheet,

  /// Centered modal dialog window.
  dialog,

  /// Adaptive presentation that automatically uses popup on desktop/tablet
  /// and bottomSheet/dialog on mobile devices based on screen width.
  adaptive,
}
