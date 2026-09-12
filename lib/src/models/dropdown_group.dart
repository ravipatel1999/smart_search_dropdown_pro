/// Container for grouped dropdown items.
class DropdownGroup<T> {
  /// Category / Group name header.
  final String name;

  /// List of items belonging to this category.
  final List<T> items;

  const DropdownGroup({
    required this.name,
    required this.items,
  });
}
