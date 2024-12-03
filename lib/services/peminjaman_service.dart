import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/peminjaman.dart';

class PeminjamanService {
  final String baseUrl = kIsWeb 
      ? 'http://localhost/pustaka_2301082020/pustaka'
      : 'http://10.0.2.2/pustaka_2301082020/pustaka';

  // Mendapatkan semua peminjaman
  Future<List<Peminjaman>> getPeminjaman(int anggotaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/peminjaman.php?anggota_id=$anggotaId')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Peminjaman.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data peminjaman');
      }
    } catch (e) {
      throw Exception('Gagal memuat data peminjaman: $e');
    }
  }

  // Membuat peminjaman baru
  Future<Map<String, dynamic>> createPeminjaman({
    required int anggotaId,
    required int bukuId,
    required String tanggalPinjam,
    required String tanggalKembali,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/peminjaman.php?action=create'),
        body: {
          'anggota_id': anggotaId.toString(),
          'buku_id': bukuId.toString(),
          'tanggal_pinjam': tanggalPinjam,
          'tanggal_kembali': tanggalKembali,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal membuat peminjaman');
      }
    } catch (e) {
      throw Exception('Gagal membuat peminjaman: $e');
    }
  }
} 