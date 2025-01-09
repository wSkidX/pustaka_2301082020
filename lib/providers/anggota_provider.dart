import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/anggota.dart';
import '../models/register.dart';
import '../models/login.dart';

class AnggotaProvider with ChangeNotifier {
  final List<Anggota> _allAnggota = [];
  final String _baseUrl =
      'http://localhost/pustaka_2301082020/pustaka/anggota.php';
  Anggota? _currentAnggota;

  List<Anggota> get allAnggota => _allAnggota;
  int get jumlahAnggota => _allAnggota.length;
  Anggota? get currentAnggota => _currentAnggota;

  Future<void> login(LoginModel loginData) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'method': 'login',
          'email': loginData.email,
          'password': loginData.password,
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        _currentAnggota = Anggota.fromJson(data['data']);
        notifyListeners();
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> register(RegisterModel registerData) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(registerData.toJson()),
      );

      final data = json.decode(response.body);
      if (data['status'] != 'success') {
        throw Exception(data['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProfile(int id, String nama, String nim, String alamat,
      String email, String foto) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl?id=$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama': nama,
          'nim': nim,
          'alamat': alamat,
          'email': email,
          'foto': foto,
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        // Update current anggota data
        if (_currentAnggota != null) {
          _currentAnggota!.nama = nama;
          _currentAnggota!.nim = nim;
          _currentAnggota!.alamat = alamat;
          _currentAnggota!.email = email;
          _currentAnggota!.foto = foto;
          notifyListeners();
        }
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  void logout() {
    _currentAnggota = null;
    notifyListeners();
  }
}
