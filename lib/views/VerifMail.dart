import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'NvMdp.dart';

class Verifmail extends StatefulWidget {
  const Verifmail({super.key, this.title = ''});
  final String title;

  @override
  State<Verifmail> createState() => _MyVerifmail();
}

class _MyVerifmail extends State<Verifmail> {
  late Timer _timer;
  int _start = 180;
  List<String> otp = List.filled(4, '');
  String? otpCode; // Variable to store the OTP received from the server

  @override
  void initState() {
    super.initState();
    startTimer();
    _requestOtp(); // Request the OTP when the widget is initialized
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get formattedTime {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _start = 180;
    });
    startTimer();
  }

  // New method to request the OTP
  Future<void> _requestOtp() async {
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT_HERE'), // Replace with your API endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': 'chouroukireda12@gmail.com'}), // Replace with the user's email
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      otpCode = data['otp_code']; // Store the OTP code received from the server
      print('OTP Code: $otpCode'); // Print or log the OTP code for debugging
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to request OTP: ${response.body}')),
      );
    }
  }

  Future<void> _submitOtp() async {
    // Join the OTP digits to form a single string
    final otpString = otp.join('');

    // Compare the entered OTP with the generated OTP from the server
    if (otpString == otpCode) {
      // OTP verified successfully
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NvMdp()),
      );
    } else {
      // OTP verification failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 210),
                child: Text(
                  "Verifier l'adresse E-mail",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xFFE42320),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Text(
                  "Voir votre boite E-mail\net entrer le code de confirmation",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xFF7F7F7F),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90.0),
                child: Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        height: 68,
                        width: 54,
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF7F7F7F),
                            fontFamily: 'Poppins',
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              otp[index] = value; // Store the OTP digit
                              if (index < 3) {
                                FocusScope.of(context).nextFocus();
                              }
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFE5E5E5),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Code expire dans  ",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xFF7F7F7F),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    TextSpan(
                      text: formattedTime,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Color(0xFFE42320),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _submitOtp, // Call the submit function
                child: Container(
                  padding: const EdgeInsets.all(17),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE42320),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Confirmer',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Color(0xFFE5E5E5),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFE42320),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _resetTimer,
                child: Container(
                  padding: const EdgeInsets.all(17),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF7F7F7F),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Renvoyer',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Color(0xFF7F7F7F),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}