import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/anggota.dart';

class AnggotaProvider with ChangeNotifier {
  final List<Anggota> _allAnggota = [];
  final String _baseUrl =
      'http://localhost/pustaka_2301082020/pustaka/anggota.php';
  Anggota? _currentAnggota;

  List<Anggota> get allAnggota => _allAnggota;
  int get jumlahAnggota => _allAnggota.length;
  Anggota? get currentAnggota => _currentAnggota;

  Anggota selectById(int id) =>
      _allAnggota.firstWhere((element) => element.id == id);

  Future<void> addAnggota(String nim, String nama, String alamat, String email,
      String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nim': nim,
          'nama': nama,
          'alamat': alamat,
          'email': email,
          'password': password,
          'tingkat': 1,
          'foto': '',
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal terhubung ke server');
      }

      final data = json.decode(response.body);
      print('Register response: $data'); // Untuk debugging

      if (data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Gagal registrasi');
      }
    } catch (error) {
      print('Error during registration: $error'); // Untuk debugging
      rethrow;
    }
  }

  Future<bool> editAnggota(int id, String nim, String nama, String alamat,
      String email, String foto, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl?id=$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nim': nim,
          'nama': nama,
          'alamat': alamat,
          'email': email,
          'foto': foto,
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        final anggota = _allAnggota.firstWhere((element) => element.id == id);
        anggota.nim = nim;
        anggota.nama = nama;
        anggota.alamat = alamat;
        anggota.email = email;
        anggota.foto = foto;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil diubah")),
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (error) {
      rethrow;
    }
  }

  void deleteAnggota(int id, BuildContext context) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl?id=$id'));
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        _allAnggota.removeWhere((element) => element.id == id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil dihapus")),
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> initialData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        final List<dynamic> anggotaList = data['data'];
        _allAnggota.clear();

        for (var anggota in anggotaList) {
          _allAnggota.add(Anggota(
            id: anggota['id'],
            nim: anggota['nim'],
            nama: anggota['nama'],
            alamat: anggota['alamat'],
            email: anggota['email'],
            password: anggota['password'],
            tingkat: anggota['tingkat'],
            foto: anggota['foto'],
          ));
        }
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'method': 'login',
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal terhubung ke server');
      }

      final data = json.decode(response.body);
      print('Response data: $data'); // Untuk debugging

      if (data['status'] == 'success' && data['data'] != null) {
        final userData = data['data'];
        _currentAnggota = Anggota(
          id: int.parse(userData['id'].toString()),
          nim: userData['nim'] ?? '',
          nama: userData['nama'] ?? '',
          alamat: userData['alamat'] ?? '',
          email: userData['email'] ?? '',
          password: userData['password'] ?? '',
          tingkat: int.parse(userData['tingkat'].toString()),
          foto: userData['foto'] ?? '',
        );
        notifyListeners();
      } else {
        throw Exception(data['message'] ?? 'Login gagal');
      }
    } catch (error) {
      print('Error during login: $error'); // Untuk debugging
      rethrow;
    }
  }

  void logout() {
    _currentAnggota = null;
    notifyListeners();
  }
}
