import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

/// Manages all cart state for the POS screen.
///
/// Offline-first design:
/// - The cart lives in memory as the source of truth for the UI.
/// - Every mutation (add/remove/increment/decrement/clear) also writes a
///   lightweight snapshot to a local Hive box.
/// - On app start, [loadFromDisk] rehydrates the cart from that snapshot,
///   so the cart survives app restarts even with zero connectivity.
class CartProvider extends ChangeNotifier {
  static const String _boxName = 'cartBox';
  static const String _cartKey = 'cart_items';

  final Map<String, CartItem> _items = {}; // productId -> CartItem
  Box? _box;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<CartItem> get items => _items.values.toList();
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.values.fold(0.0, (sum, item) => sum + item.subtotal);
  bool get isEmpty => _items.isEmpty;

  int quantityOf(String productId) => _items[productId]?.quantity ?? 0;

  /// Call once at startup (after Hive.initFlutter()) to open the box and
  /// restore any cart that was saved before the app was last closed.
  Future<void> loadFromDisk() async {
    _box = await Hive.openBox(_boxName);
    final saved = _box!.get(_cartKey);

    if (saved is List) {
      for (final entry in saved) {
        if (entry is Map) {
          final productId = entry['productId'] as String?;
          final quantity = entry['quantity'] as int?;
          final product = productId != null ? ProductCatalog.byId(productId) : null;
          if (product != null && quantity != null && quantity > 0) {
            _items[product.id] = CartItem(product: product, quantity: quantity);
          }
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void add(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    _persist();
    notifyListeners();
  }

  void decrement(Product product) {
    final existing = _items[product.id];
    if (existing == null) return;
    if (existing.quantity <= 1) {
      _items.remove(product.id);
    } else {
      existing.quantity -= 1;
    }
    _persist();
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product.id);
    _persist();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _persist();
    notifyListeners();
  }

  /// Writes a minimal snapshot (product id + quantity) to disk.
  /// Kept intentionally simple: no custom Hive TypeAdapters needed,
  /// which keeps the assignment easy to run with zero codegen steps.
  void _persist() {
    final snapshot = _items.values
        .map((item) => {'productId': item.product.id, 'quantity': item.quantity})
        .toList();
    _box?.put(_cartKey, snapshot);
  }
}
