import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/peminjaman.dart';

class PeminjamanProvider with ChangeNotifier {
  final List<Peminjaman> _allPeminjaman = [];
  final String _baseUrl =
      'http://localhost/pustaka_2301082020/pustaka/peminjaman.php';

  List<Peminjaman> get allPeminjaman => _allPeminjaman;
  int get jumlahPeminjaman => _allPeminjaman.length;

  Future<void> initialData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        final List<dynamic> peminjamanList = data['data'];
        _allPeminjaman.clear();

        for (var peminjaman in peminjamanList) {
          _allPeminjaman.add(Peminjaman.fromJson(peminjaman));
        }
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addPeminjaman(
      String tanggalPinjam, int hariPinjam, int anggota, int buku) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'tanggal_pinjam': tanggalPinjam,
          'hari_pinjam': hariPinjam,
          'anggota': anggota,
          'buku': buku,
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        await initialData(); // Refresh data setelah menambah peminjaman
      } else {
        throw Exception(data['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  // Mendapatkan peminjaman berdasarkan ID anggota
  List<Peminjaman> getPeminjamanByAnggota(int anggotaId) {
    return _allPeminjaman
        .where((peminjaman) => peminjaman.anggota == anggotaId)
        .toList();
  }

  // Mendapatkan peminjaman berdasarkan ID buku
  List<Peminjaman> getPeminjamanByBuku(int bukuId) {
    return _allPeminjaman
        .where((peminjaman) => peminjaman.buku == bukuId)
        .toList();
  }

  // Mendapatkan peminjaman yang masih aktif (status = 'Dipinjam')
  List<Peminjaman> getPeminjamanAktif() {
    return _allPeminjaman
        .where((peminjaman) => peminjaman.status == 'Dipinjam')
        .toList();
  }

  // Mendapatkan peminjaman berdasarkan ID
  Peminjaman? getPeminjamanById(int id) {
    try {
      return _allPeminjaman.firstWhere((peminjaman) => peminjaman.id == id);
    } catch (e) {
      return null;
    }
  }
}
