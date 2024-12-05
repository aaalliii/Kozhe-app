import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../models/favorites.dart';

class HomePage extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: '1',
      image: 'assets/images/product_0.png',
      title: 'Яблоко',
      price: 100,
      distance: '53 м от Вас',
    ),
    Product(
      id: '2',
      image: 'assets/images/product_1.png',
      title: 'Груша',
      price: 101,
      distance: '121 м от Вас',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kozhe', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
            },
          ),
        ],
        backgroundColor: HexColor.fromHex('669999'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image:
                        AssetImage('assets/images/recommendation_$index.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryButton(
                  iconPath: 'assets/icons/croissant.png',
                  label: 'Выпечка',
                ),
                CategoryButton(
                  iconPath: 'assets/icons/meat.png',
                  label: 'Мясо',
                ),
                CategoryButton(
                  iconPath: 'assets/icons/cheese.png',
                  label: 'Молочка',
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Novelty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String iconPath;
  final String label;

  CategoryButton({required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          iconPath,
          width: 48,
          height: 48,
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  void _addToCart(BuildContext context) {
    Cart().addItem(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.title} добавлен в корзину')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = Favorites().isFavorite(widget.product.id);

    return Card(
      elevation: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  widget.product.image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: HexColor.fromHex('669999'),
                  ),
                  onPressed: () {
                    setState(() {
                      if (isFavorite) {
                        Favorites().removeFavorite(widget.product.id);
                      } else {
                        Favorites().addFavorite(widget.product);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.product.title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('от ${widget.product.price} тг/кг',
                style: TextStyle(fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(widget.product.distance, style: TextStyle(fontSize: 12)),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _addToCart(context),
                child: Text(
                  'Добавить в корзину',
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor.fromHex('669999'),
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  minimumSize: Size(0, 32),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
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
