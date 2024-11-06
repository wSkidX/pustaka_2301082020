import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost/pustaka_2301082020/pustaka'; // Untuk emulator Android

  // static const String baseUrl = 'http://localhost/pustaka_2301082020/pustaka'; // Untuk browser

  Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String password,
    int tingkat = 2, // Default tingkat user biasa
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'nama': nama,
          'email': email,
          'password': password,
          'tingkat': tingkat.toString(),
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal melakukan registrasi');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal melakukan login');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 