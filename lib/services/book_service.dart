import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  final String baseUrl = kIsWeb 
      ? 'http://localhost/pustaka_2301082020/pustaka'
      : 'http://10.0.2.2/pustaka_2301082020/pustaka';

  // URL untuk gambar
  String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) return imagePath;
    
    return kIsWeb
        ? 'http://localhost/pustaka_2301082020/pustaka/uploads/$imagePath'
        : 'http://10.0.2.2/pustaka_2301082020/pustaka/uploads/$imagePath';
  }

  Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/books.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  Future<void> toggleSaveBook(int bukuId, int anggotaId, String action) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/books.php?action=toggle_save'),
        body: {
          'buku_id': bukuId.toString(),
          'anggota_id': anggotaId.toString(),
          'action': action,
        }
      );

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Gagal menyimpan buku');
      }
    } catch (e) {
      throw Exception('Gagal menyimpan buku: $e');
    }
  }

  Future<List<Book>> getSavedBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books.php?saved=1')
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) {
          // Ubah URL gambar sesuai platform
          if (json['cover'] != null) {
            json['cover'] = getImageUrl(json['cover']);
          }
          return Book.fromJson(json);
        }).toList();
      } else {
        throw Exception('Gagal memuat buku yang disimpan');
      }
    } catch (e) {
      throw Exception('Gagal memuat buku yang disimpan: $e');
    }
  }
} 