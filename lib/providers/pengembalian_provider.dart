import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pengembalian.dart';

class PengembalianProvider with ChangeNotifier {
  final List<Pengembalian> _allPengembalian = [];
  final String _baseUrl =
      'http://localhost/pustaka_2301082020/pustaka/pengembalian.php';

  List<Pengembalian> get allPengembalian => _allPengembalian;
  int get jumlahPengembalian => _allPengembalian.length;

  Future<void> initialData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        final List<dynamic> pengembalianList = data['data'];
        _allPengembalian.clear();

        for (var pengembalian in pengembalianList) {
          _allPengembalian.add(Pengembalian.fromJson(pengembalian));
        }
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> prosesPengembalian(
      int peminjamanId, String tanggalDikembalikan) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'peminjaman_id': peminjamanId,
          'tanggal_dikembalikan': tanggalDikembalikan,
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        await initialData(); // Refresh data setelah proses pengembalian
        return {
          'success': true,
          'terlambat': data['data']['terlambat'],
          'denda': data['data']['denda'],
          'judul_buku': data['data']['judul_buku'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'],
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': error.toString(),
      };
    }
  }

  // Mendapatkan pengembalian berdasarkan ID peminjaman
  Pengembalian? getPengembalianByPeminjamanId(int peminjamanId) {
    try {
      return _allPengembalian.firstWhere(
          (pengembalian) => pengembalian.peminjamanId == peminjamanId);
    } catch (e) {
      return null;
    }
  }

  // Mendapatkan total denda
  double getTotalDenda() {
    return _allPengembalian.fold(
        0, (total, pengembalian) => total + pengembalian.denda);
  }

  // Mendapatkan pengembalian dengan denda
  List<Pengembalian> getPengembalianDenganDenda() {
    return _allPengembalian
        .where((pengembalian) => pengembalian.denda > 0)
        .toList();
  }
}
