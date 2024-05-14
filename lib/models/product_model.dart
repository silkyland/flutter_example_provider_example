class Product {
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
];
