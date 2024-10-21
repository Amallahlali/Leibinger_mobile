import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiServiceChangePassword {
  final String baseUrl = "http://10.0.2.2:8000/api/api";
  final storage = FlutterSecureStorage();


  Future<void> changeUserPassword(String oldPassword,
      String newPassword) async {
    await _changePassword(
        '$baseUrl/web/user/change_password/', oldPassword, newPassword);
  }

  Future<void> changeClientPassword(String oldPassword,
      String newPassword) async {
    await _changePassword(
        '$baseUrl/web/client/change_password/', oldPassword, newPassword);
  }


  Future<void> changeTechnicianPassword(String oldPassword,
      String newPassword) async {
    await _changePassword(
        '$baseUrl/web/technician/change_password/', oldPassword, newPassword);
  }


  Future<void> _changePassword(String url, String oldPassword,
      String newPassword) async {
    final accessToken = await storage.read(key: 'access');
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password: ${response.reasonPhrase}');
    }
  }

}