
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpService {
  static const String baseUrl = 'http://localhost:8000';

  // Fonction pour récupérer l'OTP
  static Future<String?> fetchOTP() async {
    final response = await http.post(Uri.parse('$baseUrl/send_otp/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['otp'].toString();
    } else {
      return null;
    }
  }

  // Fonction pour vérifier l'OTP
  static Future<bool> verifyOTP(String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify_otp/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"otp": otp}),
    );
    return response.statusCode == 200;
  }
}
