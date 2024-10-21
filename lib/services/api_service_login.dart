import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiServiceLogin {
  final String baseUrl = "http://10.0.2.2:8000/api";
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('L\'email et le mot de passe ne doivent pas être vides');
    }

    final body = jsonEncode(<String, String>{
      'email': email,
      'password': password,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Login successful: ${responseData['role']}');
      return responseData;
    } else {
      print('Erreur ${response.statusCode}: ${response.body}');
      throw Exception('Échec de la connexion: ${response.reasonPhrase}');
    }
  }
}
