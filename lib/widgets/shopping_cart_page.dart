import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/favorites.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Cart cart = Cart();

  int getTotalAmount() {
    int total = 0;
    cart.items.values.forEach((item) {
      total += item.product.price * item.quantity;
    });
    return total;
  }

  void clearCart() {
    cart.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина', style: TextStyle(color: Colors.white)),
        backgroundColor: HexColor.fromHex('669999'),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Корзина пуста'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return CartItemWidget(
                  cartItem: cartItems[index],
                  onItemRemoved: () {
                    setState(() {});
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    final totalAmount = getTotalAmount();
                    return Container(
                      padding: EdgeInsets.all(16),
                      height: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Сумма заказа: $totalAmount тг',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              clearCart();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Спасибо за заказ!'),
                                    content: Text(
                                        'Вы выбрали оплату наличными. Ваш заказ успешно оформлен.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Оплатить наличными курьеру'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor:
                              HexColor.fromHex('669999'),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              clearCart();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Спасибо за заказ!'),
                                    content: Text(
                                        'Вы выбрали оплату картой. Ваш заказ успешно оформлен.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Оплатить картой в приложении'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor:
                              HexColor.fromHex('669999'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text('Заказать',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: HexColor.fromHex('669999'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;
  final VoidCallback onItemRemoved;

  CartItemWidget({required this.cartItem, required this.onItemRemoved});

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late int _quantity;
  late int _totalPrice;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    _quantity = widget.cartItem.quantity;
    _totalPrice = widget.cartItem.product.price * _quantity;
    isFavorite = Favorites().isFavorite(widget.cartItem.product.id);
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
      widget.cartItem.quantity = _quantity;
      _totalPrice = widget.cartItem.product.price * _quantity;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        widget.cartItem.quantity = _quantity;
        _totalPrice = widget.cartItem.product.price * _quantity;
      });
    } else {
      Cart().removeItem(widget.cartItem.product.id);
      widget.onItemRemoved();
    }
  }

  void _toggleFavorite() {
    setState(() {
      if (isFavorite) {
        Favorites().removeFavorite(widget.cartItem.product.id);
      } else {
        Favorites().addFavorite(widget.cartItem.product);
      }
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.cartItem.product;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset(product.image, width: 80, height: 80),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title,
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('$_totalPrice тг'),
              ],
            ),
          ),
          QuantitySelector(
            quantity: _quantity,
            onIncrease: _increaseQuantity,
            onDecrease: _decreaseQuantity,
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: HexColor.fromHex('669999'),
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  QuantitySelector({
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: onDecrease,
        ),
        Text('$quantity', style: TextStyle(fontSize: 18)),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: onIncrease,
        ),
      ],
    );
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
