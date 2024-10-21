import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leibinger_mobile/services/api_service_login.dart';
import 'package:leibinger_mobile/views/AdminDashboard.dart';
import 'package:leibinger_mobile/views/ClientDashboard.dart';
import 'package:leibinger_mobile/views/TechnicianDashboard.dart';
import 'RecupererMdp.dart';


class Homelogin extends StatefulWidget {
  const Homelogin({super.key, required this.title});

  final String title;

  @override
  State<Homelogin> createState() => _MyHomelogin();
}

class _MyHomelogin extends State<Homelogin> {
  bool _isPassVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body:
      Container(
        height: MediaQuery.of(context).size.height,
        //padding: const EdgeInsets.symmetric(horizontal: 1-.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 170),
            Container(
              height: 197,
              width: 218,
              margin: const EdgeInsets.symmetric(horizontal: 106),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/logov.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 90),
            Text(
              "Se connecter",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Color(0xFFE42320),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'lib/assets/icons/ic_email.svg',
                            fit: BoxFit.scaleDown,
                            width: 24,
                            height: 24,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            width: 0.6,
                            height: 32, // Set consistent height
                            color: const Color(0xFF7F7F7F),
                          ),
                        ],
                      ),
                    ),

                    filled: true,
                    fillColor: const Color(0xFFE5E5E5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFFFFF),
                        width: 2.5,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    hintText: "E-mail",
                    hintStyle: GoogleFonts.poppins(
                        textStyle:  const TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF7F7F7F),
                        )
                    )
                ),
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: passwordController,
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
                      color: const Color(0xFF7F7F7F),
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
                  hintText: "Mot de passe",
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
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final email = emailController.text;
                final password = passwordController.text;

                final apiService = ApiServiceLogin();

                try {
                  final result = await apiService.login(email, password);

                  if (result != null) {
                    // Récupérez le rôle de l'utilisateur depuis le résultat
                    final role = result['role'];

                    // Gérer la connexion réussie
                    Get.snackbar('Succès', 'Connexion réussie!');
                    print('Connexion réussie: ${result.toString()}');

                    // Naviguez vers le tableau de bord approprié en fonction du rôle
                    if (role == 'technician') {
                      Get.to(() => TechnicianDashboard());
                    } else if (role == 'client') {
                      Get.to(() => ClientDashboard());
                    } else if (role == 'admin') {
                      Get.to(() => AdminDashboard());
                    } else {
                      // Rôle non reconnu
                      Get.snackbar(
                          'Erreur', 'Rôle utilisateur non reconnu');
                    }
                  } else {
                    // Gérer la connexion échouée
                    Get.snackbar(
                        'Erreur', 'Email ou mot de passe invalide');
                    print(
                        'Échec de la connexion: Email ou mot de passe invalide');
                  }
                } catch (e) {
                  // Affichez l'erreur dans le terminal
                  print('Erreur: ${e.toString()}');
                  // Gérer les erreurs, par exemple les problèmes de réseau
                  Get.snackbar('Erreur',
                      'Une erreur est survenue: ${e.toString()}');
                }
              },



              child: Container(
                padding: const EdgeInsets.all(17),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: const Color(0xFFE42320),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Connexion',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Color(0xFFE5E5E5),
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFE42320),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) =>  RecupererMdp()),
                // );
                Get.to(RecupererMdp());
              },
              child: Text(
                'Mot de passe oublié ?',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color(0xFFE42320),
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFE42320),
                  ),
                ),
              ),
            )

          ],
        ),

      ),
    );
  }
}