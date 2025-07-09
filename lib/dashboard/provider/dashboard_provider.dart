import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DashboardProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
  }
}
