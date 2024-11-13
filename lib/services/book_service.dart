import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  static const String baseUrl = 'http://localhost/pustaka_2301082020/pustaka';

  Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_books.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data buku');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 