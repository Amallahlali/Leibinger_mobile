import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leibinger_mobile/services/otp_service.dart';
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
  List<String> otpDigits = List.filled(4, ''); // Renommée pour éviter le conflit
  String? otpCode;
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
    fetchOTP(); // Appel à fetchOTP pour obtenir l'OTP au démarrage
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
    fetchOTP(); // Refaire une requête OTP lors de la réinitialisation du minuteur
  }

  // Fonction pour obtenir l'OTP
  Future<void> fetchOTP() async {
    String? otpReceived = await OtpService.fetchOTP();
    setState(() {
      otpCode = otpReceived;
    });
    if (otpReceived != null) {
      print("Votre OTP est : $otpReceived");
    } else {
      print('Erreur lors de la récupération de l\'OTP');
    }
  }

  // Fonction pour vérifier l'OTP
  Future<void> verifyOTP() async {
    final otpInput = otpDigits.join(); // Joindre les chiffres pour former l'OTP complet
    bool isVerified = await OtpService.verifyOTP(otpInput);
    if (isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP vérifié avec succès')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NvMdp()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP incorrect ou invalide')),
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
                              otpDigits[index] = value;
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
                onTap: verifyOTP, // Appel à verifyOTP
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
