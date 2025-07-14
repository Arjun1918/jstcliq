import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:flutter/material.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String _errorMessage = '';
  bool _isPasswordVisible = false;
  Map? _user;
  int _otpTimer = 60;
  bool _canResendOtp = false;
  bool _isNotifying = false;

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _status == AuthStatus.loading;
  Map? get user => _user;
  int get otpTimer => _otpTimer;
  bool get canResendOtp => _canResendOtp;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (!_isNotifying) {
      _isNotifying = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isNotifying = false;
        notifyListeners();
      });
    }
  }

  void startOtpTimer() {
    _otpTimer = 60;
    _canResendOtp = false;
    _safeNotifyListeners();
  }

  void updateOtpTimer(int time) {
    _otpTimer = time;
    if (_otpTimer == 0) {
      _canResendOtp = true;
    }
    _safeNotifyListeners();
  }

  void enableResendOtp() {
    _canResendOtp = true;
    _safeNotifyListeners();
  }

  void triggerUpdate() {
    _safeNotifyListeners();
  }

  Future<bool> login(String mobile, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
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

  Future<bool> verifyOTP(String otp) async {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      // Replace this with your actual OTP verification API call
      await Future.delayed(const Duration(seconds: 2));

      if (otp.length == 6) {
        _status = AuthStatus.authenticated;
        _user = {'isLoggedIn': true, 'otpVerified': true};
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Invalid OTP';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'OTP verification failed. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendOTP(String mobileNumber) async {
    try {
      // Replace this with your actual resend OTP API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Reset timer after successful resend
      startOtpTimer();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to resend OTP';
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