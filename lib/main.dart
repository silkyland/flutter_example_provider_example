import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_demo/screens/product_list_screen.dart';
import 'package:provider/provider.dart';

import 'models/cart_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping Cart Demo',
        home: ProductListScreen(),
      ),
    );
  }
}
