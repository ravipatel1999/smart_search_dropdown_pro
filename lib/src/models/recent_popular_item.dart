/// Categorized item wrapper for Recent or Popular items.
enum RecentPopularType { recent, popular, normal }

class RecentPopularItem<T> {
  final T item;
  final RecentPopularType type;

  const RecentPopularItem({
    required this.item,
    required this.type,
  });
}
