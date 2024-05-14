#!/bin/bash

# Create the directory structure
mkdir -p lib/models
mkdir -p lib/screens

# Create the pubspec.yaml file
cat <<EOL > pubspec.yaml
name: flutter_shopping_cart_demo
description: A new Flutter project.

publish_to: 'none' # Remove this line if you want to publish to pub.dev

version: 1.0.0+1

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
EOL

# Create the CartModel file
echo "import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  void addItem(String productId, String name, double price, int quantity) {
    if (_items.any((item) => item.id == productId)) {
      _items.firstWhere((item) => item.id == productId).quantity += quantity;
    } else {
      _items.add(CartItem(
        id: productId,
        name: name,
        price: price,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}" > lib/models/cart_model.dart

# Create the ProductModel file
echo "class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

final List<Product> products = [
  Product(id: '1', name: 'Pencil', price: 5.0),
  Product(id: '2', name: 'Pen', price: 10.0),
  Product(id: '3', name: 'Eraser', price: 3.0),
  Product(id: '4', name: 'Ruler', price: 7.0),
  Product(id: '5', name: 'Marker', price: 15.0),
];" > lib/models/product_model.dart

# Create the main.dart file
echo "import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cart_model.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        title: 'Shopping Cart Demo',
        home: ProductListScreen(),
      ),
    );
  }
}" > lib/main.dart

# Create the ProductListScreen file
echo "import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stationery'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                Provider.of<CartModel>(context, listen: false).addItem(
                  product.id,
                  product.name,
                  product.price,
                  1,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to cart')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}" > lib/screens/product_list_screen.dart

# Create the CartScreen file
echo "import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0) {
            return Center(child: Text('Your cart is empty'));
          }
          return ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('Quantity: \${item.quantity}'),
                trailing: Text('\${item.price * item.quantity}'),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartModel>(
        builder: (context, cart, child) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \${cart.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Buying not supported yet.')),
                    );
                  },
                  child: Text('BUY'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}" > lib/screens/cart_screen.dart

echo "Flutter shopping cart project files and directories created successfully!"
