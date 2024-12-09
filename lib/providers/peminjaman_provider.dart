import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/peminjaman.dart';

class PeminjamanProvider with ChangeNotifier {
  List<Peminjaman> _peminjamanList = [];
  List<Peminjaman> get peminjamanList => _peminjamanList;

  Future<void> fetchPeminjaman() async {
    try {
      const baseUrl = 'http://localhost/pustaka_2301082020/pustaka/peminjaman.php';
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _peminjamanList = (data['data'] as List).map((item) => Peminjaman(
            id: int.parse(item['id'].toString()),
            tanggalPinjam: item['tanggal_pinjam'],
            tanggalKembali: item['tanggal_kembali'],
            anggota: int.parse(item['anggota'].toString()),
            buku: int.parse(item['buku'].toString()),
            namaAnggota: item['nama_anggota'],
            judulBuku: item['judul_buku'],
            cover: item['cover'],
          )).toList();
          notifyListeners();
        }
      }
    } catch (error) {
      print('Error fetching peminjaman: $error');
    }
  }

  Future<bool> addPeminjaman(String tanggalPinjam, String tanggalKembali, int anggotaId, int bukuId) async {
    const baseUrl = 'http://localhost/pustaka_2301082020/pustaka/peminjaman.php';
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: json.encode({
          'tanggal_pinjam': tanggalPinjam,
          'tanggal_kembali': tanggalKembali,
          'anggota': anggotaId,
          'buku': bukuId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          await fetchPeminjaman(); // Refresh data
          return true;
        }
      }
      return false;
    } catch (error) {
      return false;
    }
  }
} 