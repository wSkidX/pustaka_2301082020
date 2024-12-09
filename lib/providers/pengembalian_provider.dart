import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pengembalian.dart';

class PengembalianProvider with ChangeNotifier {
  List<Pengembalian> _pengembalianList = [];
  List<Pengembalian> get pengembalianList => _pengembalianList;

  Future<void> fetchPengembalian() async {
    try {
      const baseUrl = 'http://localhost/pustaka_2301082020/pustaka/pengembalian.php';
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _pengembalianList = (data['data'] as List).map((item) => Pengembalian(
            id: int.parse(item['id'].toString()),
            tanggalDikembalikan: item['tanggal_dikembalikan'],
            terlambat: int.parse(item['terlambat'].toString()),
            denda: double.parse(item['denda'].toString()),
            peminjamanId: int.parse(item['peminjaman_id'].toString()),
            tanggalPinjam: item['tanggal_pinjam'],
            tanggalKembali: item['tanggal_kembali'],
            namaAnggota: item['nama_anggota'],
            judulBuku: item['judul_buku'],
            cover: item['cover'],
          )).toList();
          notifyListeners();
        }
      }
    } catch (error) {
      print('Error fetching pengembalian: $error');
    }
  }

  Future<Map<String, dynamic>?> addPengembalian(String tanggalDikembalikan, int peminjamanId) async {
    const baseUrl = 'http://localhost/pustaka_2301082020/pustaka/pengembalian.php';
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'tanggal_dikembalikan': tanggalDikembalikan,
          'peminjaman_id': peminjamanId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          await fetchPengembalian(); // Refresh data
          return {
            'success': true,
            'terlambat': data['data']['terlambat'],
            'denda': data['data']['denda'],
          };
        }
      }
      return {'success': false};
    } catch (error) {
      return {'success': false};
    }
  }
} 