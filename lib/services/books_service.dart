import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  final String baseUrl = kIsWeb 
      ? 'http://localhost/pustaka_2301082020/pustaka'
      : 'http://10.0.2.2/pustaka_2301082020/pustaka';

  Future<List<Book>> getBooks({String? category}) async {
    try {
      final uri = Uri.parse('$baseUrl/books.php').replace(
        queryParameters: category != null ? {'category': category} : null,
      );
      
      print('Requesting URL: $uri');
      
      final response = await http.get(uri);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) {
          print('Cover URL: ${json['cover']}');
          print('Banner URL: ${json['book_banner']}');
          return Book.fromJson(json);
        }).toList();
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getBooks: $e');
      throw Exception('Failed to load books: $e');
    }
  }

  Future<void> toggleSaveBook(
    int bukuId,
    int anggotaId,
    String action,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/books.php?action=$action'),
        body: {
          'buku_id': bukuId.toString(),
          'anggota_id': anggotaId.toString(),
        },
      );

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Gagal menyimpan buku');
      }
    } catch (e) {
      throw Exception('Gagal menyimpan buku: $e');
    }
  }
} 