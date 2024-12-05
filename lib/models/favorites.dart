import 'product.dart';

class Favorites {
  static final Favorites _instance = Favorites._internal();

  factory Favorites() {
    return _instance;
  }

  Favorites._internal();

  final Map<String, Product> _items = {};

  void addFavorite(Product product) {
    _items[product.id] = product;
  }

  void removeFavorite(String productId) {
    _items.remove(productId);
  }

  bool isFavorite(String productId) {
    return _items.containsKey(productId);
  }

  List<Product> get items => _items.values.toList();
}
