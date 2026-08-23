class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String emoji;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.emoji,
  });
}

/// Static in-memory product catalog for the prototype.
/// In a real POS this would come from a local DB synced with a backend.
class ProductCatalog {
  static const List<Product> products = [
    Product(id: 'p1', name: 'Coffee', price: 120, category: 'Beverages', emoji: '☕'),
    Product(id: 'p2', name: 'Cold Brew', price: 150, category: 'Beverages', emoji: '🧋'),
    Product(id: 'p3', name: 'Sandwich', price: 180, category: 'Food', emoji: '🥪'),
    Product(id: 'p4', name: 'Burger', price: 220, category: 'Food', emoji: '🍔'),
    Product(id: 'p5', name: 'Fries', price: 90, category: 'Food', emoji: '🍟'),
    Product(id: 'p6', name: 'Croissant', price: 110, category: 'Bakery', emoji: '🥐'),
    Product(id: 'p7', name: 'Donut', price: 70, category: 'Bakery', emoji: '🍩'),
    Product(id: 'p8', name: 'Muffin', price: 95, category: 'Bakery', emoji: '🧁'),
    Product(id: 'p9', name: 'Iced Tea', price: 100, category: 'Beverages', emoji: '🧊'),
    Product(id: 'p10', name: 'Pasta', price: 210, category: 'Food', emoji: '🍝'),
  ];

  static Product? byId(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
