import 'package:flutter/material.dart';

class CartItem {
  final String fruitName;
  final String title;
  final String imagePath;
  final String weight;
  final String price;
  final String mrp;
  final String displayName;
  int quantity;

  CartItem({
    required this.fruitName,
    required this.title,
    required this.imagePath,
    required this.weight,
    required this.price,
    required this.mrp,
    required this.displayName,
    required this.quantity,
  });

  double get numericPrice => double.parse(price.replaceAll('₹ ', ''));
  double get totalPrice => numericPrice * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  
  List<CartItem> get items => List.unmodifiable(_items);
  
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => _items.isEmpty;

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((cartItem) => cartItem.fruitName == item.fruitName);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(String fruitName, int quantity) {
    final index = _items.indexWhere((item) => item.fruitName == fruitName);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void removeItem(String fruitName) {
    _items.removeWhere((item) => item.fruitName == fruitName);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int getItemQuantity(String fruitName) {
    final item = _items.firstWhere(
      (item) => item.fruitName == fruitName,
      orElse: () => CartItem(
        fruitName: '',
        title: '',
        imagePath: '',
        weight: '',
        price: '₹ 0',
        mrp: '₹ 0',
        displayName: '',
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}