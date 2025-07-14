import 'package:flutter/material.dart';
import 'package:kods/menu_drawer/my_services/model/service_model.dart';

class ServicesProvider extends ChangeNotifier {
  final List<ServiceModel> _services = [];
  final List<String> _categories = ['General Service', 'Cleaning', 'Repair', 'Installation'];
  String? _selectedImagePath;

  List<ServiceModel> get services => _services;
  List<String> get categories => _categories;
  String? get selectedImagePath => _selectedImagePath;

  void addService(String name, String category, String imagePath, double cost) {
    final service = ServiceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      imagePath: imagePath,
      cost: cost,
    );
    _services.add(service);
    notifyListeners();
  }

  void removeService(String id) {
    _services.removeWhere((service) => service.id == id);
    notifyListeners();
  }

  void setImagePath(String path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  void clearImagePath() {
    _selectedImagePath = null;
    notifyListeners();
  }
}
