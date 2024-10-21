import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiServiceLogout {
  final String baseUrl = "http://10.0.2.2:8000/api/api";
  final storage = FlutterSecureStorage();


  Future<void> logoutUser() async {
    await _logout('$baseUrl/web/user/logout/');
  }


  Future<void> logoutClient() async {
    await _logout('$baseUrl/web/client/logout/');
  }


  Future<void> logoutTechnician() async {
    await _logout('$baseUrl/web/technician/logout/');
  }

  Future<void> _logout(String url) async {
    final accessToken = await storage.read(key: 'access');
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to logout: ${response.reasonPhrase}');
    }
  }
}