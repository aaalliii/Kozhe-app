import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/product.dart';
import '../models/cart.dart';

class ProductItem {
  final Product product;
  int quantity;

  ProductItem({required this.product, required this.quantity});
}

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final LatLng _almatyCenter = LatLng(43.238949, 76.889709);
  MapController mapController = MapController();

  List<Marker> _markers = [];

  // List of menu items
  List<ProductItem> menuItems = [
    ProductItem(
      product: Product(
        id: '1',
        image: 'assets/images/product_0.png',
        title: 'Яблоко',
        price: 100,
        distance: '53 м от Вас',
      ),
      quantity: 10,
    ),
    ProductItem(
      product: Product(
        id: '2',
        image: 'assets/images/product_1.png',
        title: 'Груша',
        price: 101,
        distance: '121 м от Вас',
      ),
      quantity: 8,
    ),
    ProductItem(
      product: Product(
        id: '3',
        image: 'assets/images/water.png',
        title: 'Вода',
        price: 160,
        distance: '',
      ),
      quantity: 15,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _markers.add(
      Marker(
        point: _almatyCenter,
        width: 80,
        height: 80,
        builder: (ctx) => GestureDetector(
          onTap: () => _showMenu(context),
          child: Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40,
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 400,
              color: HexColor.fromHex('669999'),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Кафе А',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('Адрес xxx 11.78km',
                        style: TextStyle(color: Colors.white70)),
                    trailing: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return ListTile(
                          title: Text(
                            '${item.product.title}',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Осталось: ${item.quantity}',
                            style: TextStyle(color: Colors.white70),
                          ),
                          trailing: Text(
                            '${item.product.price} тг',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            if (item.quantity > 0) {
                              // Add item to cart
                              Cart().addItem(item.product);

                              // Decrease quantity
                              setState(() {
                                item.quantity--;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${item.product.title} добавлен в корзину'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${item.product.title} закончился на складе'),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: _almatyCenter,
          zoom: 16.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _markers,
          ),
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
