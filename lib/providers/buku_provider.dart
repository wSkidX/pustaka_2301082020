import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/buku.dart';

class BukuProvider with ChangeNotifier {
  final List<Buku> _allBuku = [];
  final String _baseUrl = 'http://localhost/pustaka_2301082020/pustaka/buku.php';
  
  List<Buku> get allBuku => _allBuku;
  int get jumlahBuku => _allBuku.length;

  Buku selectById(int id) =>
      _allBuku.firstWhere((element) => element.idBuku == id);

  Future<void> addBuku(String judul, String pengarang, String penerbit, 
      String tahunTerbit, String kategori, String cover, String deskripsi) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'judul': judul,
          'pengarang': pengarang,
          'penerbit': penerbit,
          'tahun_terbit': tahunTerbit,
          'kategori': kategori,
          'cover': cover,
          'deskripsi': deskripsi,
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        _allBuku.add(
          Buku(
            idBuku: data['data']['id_buku'],
            judul: judul,
            pengarang: pengarang,
            penerbit: penerbit,
            tahunTerbit: tahunTerbit,
            kategori: kategori,
            cover: cover,
            deskripsi: deskripsi,
          ),
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  void editBuku(int id, String judul, String pengarang, String penerbit,
      String tahunTerbit, String kategori, String cover, String deskripsi, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl?id=$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'judul': judul,
          'pengarang': pengarang,
          'penerbit': penerbit,
          'tahun_terbit': tahunTerbit,
          'kategori': kategori,
          'cover': cover,
          'deskripsi': deskripsi,
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        final buku = _allBuku.firstWhere((element) => element.idBuku == id);
        buku.judul = judul;
        buku.pengarang = pengarang;
        buku.penerbit = penerbit;
        buku.tahunTerbit = tahunTerbit;
        buku.kategori = kategori;
        buku.cover = cover;
        buku.deskripsi = deskripsi;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Buku berhasil diubah")),
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  void deleteBuku(int id, BuildContext context) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl?id=$id'));
      final data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        _allBuku.removeWhere((element) => element.idBuku == id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Buku berhasil dihapus")),
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> initialData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      final data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        final List<dynamic> bukuList = data['data'];
        _allBuku.clear();
        
        for (var buku in bukuList) {
          _allBuku.add(Buku(
            idBuku: int.parse(buku['id_buku'].toString()),
            judul: buku['judul'],
            pengarang: buku['pengarang'],
            penerbit: buku['penerbit'],
            tahunTerbit: buku['tahun_terbit'],
            kategori: buku['kategori'],
            cover: buku['cover'],
            deskripsi: buku['deskripsi'],
          ));
        }
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}