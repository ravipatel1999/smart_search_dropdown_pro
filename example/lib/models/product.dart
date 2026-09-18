/// E-commerce product model for developer examples.
class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final bool inStock;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    this.inStock = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => title;
}

const sampleProducts = [
  Product(
      id: 'p1',
      title: 'MacBook Pro 16"',
      category: 'Electronics',
      price: 2499.99,
      rating: 4.9),
  Product(
      id: 'p2',
      title: 'Wireless Headphones',
      category: 'Audio',
      price: 199.99,
      rating: 4.7),
  Product(
      id: 'p3',
      title: 'Mechanical Keyboard',
      category: 'Peripherals',
      price: 149.50,
      rating: 4.8),
  Product(
      id: 'p4',
      title: 'Ergonomic Desk Chair',
      category: 'Furniture',
      price: 399.00,
      rating: 4.6),
  Product(
      id: 'p5',
      title: '4K Ultra HD Monitor',
      category: 'Displays',
      price: 499.99,
      rating: 4.7),
  Product(
      id: 'p6',
      title: 'Smart Watch Series 9',
      category: 'Wearables',
      price: 349.99,
      rating: 4.5),
  Product(
      id: 'p7',
      title: 'USB-C Docking Station',
      category: 'Accessories',
      price: 89.99,
      rating: 4.4),
  Product(
      id: 'p8',
      title: 'Noise Cancelling Earbuds',
      category: 'Audio',
      price: 129.99,
      rating: 4.6),
];
