import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NvMdp extends StatefulWidget {
  const NvMdp({super.key, this.title = ''});
  final String title;

  @override
  State<NvMdp> createState() => _MyNvMdp();
}

class _MyNvMdp extends State<NvMdp> {
  bool _isPassVisible = false;


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
                  "Réinitialiser le mot de passe",
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
                  "Veuillez saisir votre\nnouveau mot de passe",
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
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  obscureText: !_isPassVisible,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'lib/assets/icons/ic-password.svg',
                            fit: BoxFit.scaleDown,
                            width: 24,
                            height: 24,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: 0.6,
                            height: 32, // Set consistent height
                            color: const Color(0xFF7F7F7F),
                          ),
                        ],
                      ),
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        color: Color(0xFF7F7F7F),
                        _isPassVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPassVisible = !_isPassVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E5E5),
                        width: 2.5,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    hintText: "Nouveau mot de passe",
                    hintStyle: GoogleFonts.poppins(
                      textStyle:  const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF7F7F7F),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  obscureText: !_isPassVisible,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'lib/assets/icons/ic-password.svg',
                            fit: BoxFit.scaleDown,
                            width: 24,
                            height: 24,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: 0.6,
                            height: 32, // Set consistent height
                            color: const Color(0xFF7F7F7F),
                          ),
                        ],
                      ),
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        color: Color(0xFF7F7F7F),
                        _isPassVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPassVisible = !_isPassVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFE5E5E5),
                        width: 2.5,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    hintText: "Confirmer le mot de passe",
                    hintStyle: GoogleFonts.poppins(
                      textStyle:  const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF7F7F7F),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(17),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE42320),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Enregistrer',
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
            ],
          ),
        ),
      ),
    );
  }
}