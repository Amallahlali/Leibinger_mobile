import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiServiceResetPassword {
  final String baseUrl = "http://10.0.2.2:8000/api/api";
  final storage = FlutterSecureStorage();


  Future<void> resetUserPassword(String email) async {
    await _resetPassword('$baseUrl/web/user/reset_password/', email);
  }


  Future<void> resetClientPassword(String email) async {
    await _resetPassword('$baseUrl/web/client/reset_password/', email);
  }

  Future<void> resetTechnicianPassword(String email) async {
    await _resetPassword('$baseUrl/web/technician/reset_password/', email);
  }

  Future<void> _resetPassword(String url, String email) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset password: ${response.reasonPhrase}');
    }
  }
}