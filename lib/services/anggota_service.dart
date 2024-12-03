import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AuthService {
  final String baseUrl = kIsWeb 
      ? 'http://localhost/pustaka_2301082020/pustaka'
      : 'http://10.0.2.2/pustaka_2301082020/pustaka';

  // URL untuk gambar
  String getImageUrl(String imagePath) {
    return kIsWeb
        ? 'http://localhost/pustaka_2301082020/pustaka/$imagePath'
        : 'http://10.0.2.2/pustaka_2301082020/pustaka/$imagePath';
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Ubah URL foto jika ada
        if (data['data'] != null && data['data']['foto'] != null) {
          data['data']['foto'] = getImageUrl(data['data']['foto']);
        }
        return data;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal login: $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=register'),
        body: {
          'nama': nama,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal register: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required int id,
    required String nama,
    required String email,
    String? nim,
    String? alamat,
    XFile? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/auth.php?action=update_profile'),
      );

      // Debug print
      print('Sending update profile request to: ${request.url}');

      request.fields['id'] = id.toString();
      request.fields['nama'] = nama;
      request.fields['email'] = email;
      if (nim != null) request.fields['nim'] = nim;
      if (alamat != null) request.fields['alamat'] = alamat;

      if (imageFile != null) {
        print('Preparing to upload image: ${imageFile.path}');
        
        if (kIsWeb) {
          // Handle web
          final bytes = await imageFile.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'foto',
              bytes,
              filename: imageFile.name,
            ),
          );
        } else {
          // Handle mobile
          request.files.add(
            await http.MultipartFile.fromPath('foto', imageFile.path),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      // Debug print
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }
} 