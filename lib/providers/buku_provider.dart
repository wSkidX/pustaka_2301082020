import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/buku.dart';

class BukuProvider with ChangeNotifier {
  List<Buku> _bukuList = [];
  List<Buku> get bukuList => _bukuList;

  Future<void> fetchBuku() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/pustaka_2301082020/pustaka/buku.php'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _bukuList = (data['data'] as List).map((item) => Buku(
            idBuku: int.parse(item['id_buku'].toString()),
            judul: item['judul'],
            pengarang: item['pengarang'],
            penerbit: item['penerbit'],
            tahunTerbit: item['tahun_terbit'],
            kategori: item['kategori'],
            cover: item['cover'],
            deskripsi: item['deskripsi'],
          )).toList();
          notifyListeners();
        }
      }
    } catch (error) {
      print('Error fetching buku: $error');
    }
  }
} 