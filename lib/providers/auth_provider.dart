import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _email;
  String? _nama;
  String? _errorMessage;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  String? get userName => _nama;
  String? get email => _email;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final AuthService _authService = AuthService();

  Future<bool> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _authService.register(
        nama: nama,
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();

      if (response['status'] == 'success') {
        return true;
      } else {
        errorMessage = response['message'];
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _authService.login(
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();

      if (response['status'] == 'success') {
        _email = response['data']['email'];
        _nama = response['data']['nama'];
        _isLoggedIn = true;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
} 