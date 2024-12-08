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
          _pengembalianList = Pengembalian.fromJsonList(data['data']);
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
      print('Error adding pengembalian: $error');
      return {'success': false};
    }
  }
} 