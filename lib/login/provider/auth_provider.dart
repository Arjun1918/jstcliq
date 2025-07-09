import 'package:flutter/foundation.dart';

import 'dart:async';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String _errorMessage = '';
  bool _isPasswordVisible = false;
  Map<String, dynamic>? _user;

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _status == AuthStatus.loading;
  Map<String, dynamic>? get user => _user;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

Future<bool> login(String mobile, String password) async {
  _status = AuthStatus.loading;
  _errorMessage = '';
  notifyListeners();

  try {
    // Replace this with your actual API call
    await Future.delayed(const Duration(seconds: 2));

    if (mobile.isNotEmpty) {
      _status = AuthStatus.authenticated;
      _user = {'mobile': mobile, 'isLoggedIn': true};
      notifyListeners();
      return true;
    } else {
      _status = AuthStatus.error;
      _errorMessage = 'Please enter your mobile number';
      notifyListeners();
      return false;
    }
  } catch (e) {
    _status = AuthStatus.error;
    _errorMessage = 'Login failed. Please try again.';
    notifyListeners();
    return false;
  }
}

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          mobile.isNotEmpty &&
          email.isNotEmpty) {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Please fill all required fields';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'Registration failed. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _status = AuthStatus.unauthenticated;
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void setInitialStatus() {
    _status = AuthStatus.initial;
    notifyListeners();
  }

  void setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
