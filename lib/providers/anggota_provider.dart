import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/anggota.dart';

class AnggotaProvider with ChangeNotifier {
  final String _baseUrl = 'http://localhost/pustaka_2301082020/pustaka/anggota.php';
  List<Anggota> _anggotaList = [];
  Anggota? _currentAnggota;

  List<Anggota> get anggotaList => _anggotaList;
  Anggota? get currentAnggota => _currentAnggota;

  // Mengambil semua data anggota
  Future<void> fetchAnggota() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final List<Anggota> loadedAnggota = [];
          for (var anggota in data['data']) {
            loadedAnggota.add(Anggota(
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
          _anggotaList = loadedAnggota;
          notifyListeners();
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  // Menambah anggota baru
  Future<void> addAnggota(Anggota anggota) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nim': anggota.nim,
          'nama': anggota.nama,
          'alamat': anggota.alamat,
          'email': anggota.email,
          'password': anggota.password,
          'tingkat': 2,
          'foto': ''
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] != 'success') {
          throw Exception(data['message'] ?? 'Gagal menambahkan anggota');
        }
      } else {
        throw Exception('Gagal menambahkan anggota: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Mengupdate data anggota
  Future<void> updateAnggota(int id, Anggota anggota) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl?id=$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama': anggota.nama,
          'nim': anggota.nim,
          'alamat': anggota.alamat,
          'email': anggota.email,
          'tingkat': anggota.tingkat,
          'foto': anggota.foto,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          // Update current anggota juga
          setCurrentAnggota(anggota);
          await fetchAnggota();
        } else {
          throw Exception(data['message'] ?? 'Gagal memperbarui profil');
        }
      } else {
        throw Exception('Gagal memperbarui profil: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Menghapus data anggota
  Future<void> deleteAnggota(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl?id=$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          await fetchAnggota();
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  // Method untuk set anggota yang login
  void setCurrentAnggota(Anggota? anggota) {
    _currentAnggota = anggota;
    notifyListeners();
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final anggota = Anggota(
            id: int.parse(data['data']['id'].toString()),
            nim: data['data']['nim'],
            nama: data['data']['nama'],
            alamat: data['data']['alamat'],
            email: data['data']['email'],
            password: data['data']['password'],
            tingkat: int.parse(data['data']['tingkat'].toString()),
            foto: data['data']['foto'],
          );
          setCurrentAnggota(anggota);
        } else {
          throw Exception(data['message'] ?? 'Login gagal');
        }
      } else {
        throw Exception('Login gagal');
      }
    } catch (error) {
      rethrow;
    }
  }
}
