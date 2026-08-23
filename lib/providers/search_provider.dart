import 'package:flutter/foundation.dart';

import '../models/product.dart';

class SearchProvider extends ChangeNotifier {
  String _query = '';

  String get query => _query;

  List<Product> get filteredProducts {
    if (_query.trim().isEmpty) return ProductCatalog.products;
    final q = _query.toLowerCase();
    return ProductCatalog.products
        .where((p) =>
            p.name.toLowerCase().contains(q) || p.category.toLowerCase().contains(q))
        .toList();
  }

  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void clear() {
    _query = '';
    notifyListeners();
  }
}
