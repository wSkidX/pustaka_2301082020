import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://localhost/pustaka_2301082020/pustaka'; // Sesuaikan dengan IP/domain Anda

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

      return json.decode(response.body);
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        body: {
          'nama': nama,
          'email': email,
          'password': password,
        },
      );

      return json.decode(response.body);
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String nama,
    required String email,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/update_profile.php'),
      );

      request.fields['nama'] = nama;
      request.fields['email'] = email;

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto',
          imageFile.path,
        ));
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      return json.decode(responseData);
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }
} 