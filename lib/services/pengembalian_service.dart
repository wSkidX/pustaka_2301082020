import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/pengembalian.dart';

class PengembalianService {
  final String baseUrl = kIsWeb 
      ? 'http://localhost/pustaka_2301082020/pustaka'
      : 'http://10.0.2.2/pustaka_2301082020/pustaka';

  // Mendapatkan data pengembalian
  Future<List<Pengembalian>> getPengembalian(int anggotaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pengembalian.php?anggota_id=$anggotaId')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Pengembalian.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data pengembalian');
      }
    } catch (e) {
      throw Exception('Gagal memuat data pengembalian: $e');
    }
  }

  // Membuat pengembalian baru
  Future<Map<String, dynamic>> createPengembalian({
    required int peminjamanId,
    required String tanggalDikembalikan,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pengembalian.php?action=create'),
        body: {
          'peminjaman_id': peminjamanId.toString(),
          'tanggal_pengembalian': tanggalDikembalikan,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal membuat pengembalian');
      }
    } catch (e) {
      throw Exception('Gagal membuat pengembalian: $e');
    }
  }
} 