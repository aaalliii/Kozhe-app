import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class Cart {
  static final Cart _instance = Cart._internal();

  factory Cart() {
    return _instance;
  }

  Cart._internal();

  final Map<String, CartItem> _items = {};

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
  }

  Map<String, CartItem> get items => _items;

  void clear() {
    _items.clear();
  }
}


