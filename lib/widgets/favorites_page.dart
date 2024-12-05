import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/favorites.dart';
import '../models/cart.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final Favorites favorites = Favorites();

  @override
  Widget build(BuildContext context) {
    final favoriteItems = favorites.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное', style: TextStyle(color: Colors.white)),
        backgroundColor: HexColor.fromHex('669999'),
        centerTitle: true,
      ),
      body: favoriteItems.isEmpty
          ? Center(child: Text('Список избранных пуст'))
          : ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          Product product = favoriteItems[index];
          final isFavorite = favorites.isFavorite(product.id);
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: HexColor.fromHex('669999'),
                        ),
                        onPressed: () {
                          setState(() {
                            if (isFavorite) {
                              favorites.removeFavorite(product.id);
                            } else {
                              favorites.addFavorite(product);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('от ${product.price} тг/кг'),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Cart().addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                            Text('${product.title} добавлен в корзину')),
                      );
                    },
                    child: Text('Добавить в корзину'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor.fromHex('669999'),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
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
