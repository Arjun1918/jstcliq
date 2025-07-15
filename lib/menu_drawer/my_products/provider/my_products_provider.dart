import 'package:flutter/material.dart';
import 'package:kods/menu_drawer/my_products/model/my_products.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _products = [];
  final List<String> _categories = [
    'Fruits',
    'Vegetables',
    'Chocolates',
    'Dairy Products',
  ];
  
  String? _selectedImagePath;

  List<ProductModel> get products => _products;
  List<String> get categories => _categories;
  String? get selectedImagePath => _selectedImagePath;

  void addProduct(String name, String category, String imagePath, double cost) {
    final product = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      imagePath: imagePath,
      cost: cost,
    );

    _products.add(product);
    notifyListeners();
  }

  void removeproduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  // Add method to set selected image path
  void setSelectedImagePath(String? path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  // Add method to clear selected image path
  void clearSelectedImagePath() {
    _selectedImagePath = null;
    notifyListeners();
  }
}