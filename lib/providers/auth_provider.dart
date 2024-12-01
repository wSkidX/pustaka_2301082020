import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/auth.dart';

class AuthProvider extends ChangeNotifier {
  Auth? _auth;
  String? _errorMessage;
  bool _isLoading = false;
  String? _userName;
  String? _email;
  int? _userId;
  int? _tingkat;
  String? _foto;
  String? _alamat;

  Auth? get auth => _auth;
  bool get isLoggedIn => _auth != null;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String? get userName => _userName;
  String? get email => _email;
  int? get userId => _userId;
  int? get tingkat => _tingkat;
  String? get foto => _foto;
  String? get alamat => _alamat;

  final AuthService _authService = AuthService();

  Future<bool> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authService.register(
        nama: nama,
        email: email,
        password: password,
      );

      if (response['status'] == 'success') {
        return true;
      } else {
        throw Exception(response['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      _errorMessage = e.toString();
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response['status'] == 'success' && response['data'] != null) {
        _auth = Auth.fromJson(response['data']);
        setUserData(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Login gagal');
      }
    } catch (e) {
      _errorMessage = e.toString();
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _auth = null;
    clearUserData();
    notifyListeners();
  }

  void setUserData(Map<String, dynamic> userData) {
    _userName = userData['nama'];
    _email = userData['email'];
    _userId = int.parse(userData['id'].toString());
    _tingkat = int.parse(userData['tingkat'].toString());
    _foto = userData['foto'];
    _alamat = userData['alamat'];
    notifyListeners();
  }

  void clearUserData() {
    _userName = null;
    _email = null;
    _userId = null;
    _tingkat = null;
    _foto = null;
    _alamat = null;
    notifyListeners();
  }
} 