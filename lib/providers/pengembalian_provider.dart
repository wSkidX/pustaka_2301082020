import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pengembalian.dart';

class PengembalianProvider with ChangeNotifier {
  final List<Pengembalian> _allPengembalian = [];
  final String _baseUrl = 'http://localhost/pustaka_2301082020/pustaka/pengembalian.php';
  
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
          _allPengembalian.add(Pengembalian(
            id: int.parse(pengembalian['id'].toString()),
            tanggalDikembalikan: pengembalian['tanggal_dikembalikan'],
            terlambat: int.parse(pengembalian['terlambat'].toString()),
            denda: double.parse(pengembalian['denda'].toString()),
            peminjamanId: int.parse(pengembalian['peminjaman_id'].toString()),
            tanggalPinjam: pengembalian['tanggal_pinjam'],
            tanggalKembali: pengembalian['tanggal_kembali'],
            namaAnggota: pengembalian['nama_anggota'],
            judulBuku: pengembalian['judul_buku'],
            cover: pengembalian['cover'],
          ));
        }
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addPengembalian(String tanggalDikembalikan, int peminjamanId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'tanggal_dikembalikan': tanggalDikembalikan,
          'peminjaman_id': peminjamanId,
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        await initialData(); // Refresh data
        return {
          'success': true,
          'terlambat': int.parse(data['data']['terlambat'].toString()),
          'denda': double.parse(data['data']['denda'].toString()),
        };
      }
      return {'success': false};
    } catch (error) {
      print('Error adding pengembalian: $error');
      return {'success': false};
    }
  }
} 