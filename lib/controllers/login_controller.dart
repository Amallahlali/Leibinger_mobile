import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leibinger_mobile/services/api_service_login.dart';
import 'package:leibinger_mobile/views/AdminDashboard.dart';
import 'package:leibinger_mobile/views/ClientDashboard.dart';
import 'package:leibinger_mobile/views/TechnicianDashboard.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isPassVisible = false.obs; // Pour gérer la visibilité du mot de passe

  // Méthode de connexion
  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    final apiService = ApiServiceLogin();

    try {
      final result = await apiService.login(email, password);

      if (result != null) {
        final role = result['role'];

        // Gérer la connexion réussie
        Get.snackbar('Succès', 'Connexion réussie!');
        print('Connexion réussie: ${result.toString()}');

        // Naviguer vers le tableau de bord approprié
        if (role == 'technician') {
          Get.to(() => TechnicianDashboard());
        } else if (role == 'client') {
          Get.to(() => ClientDashboard());
        } else if (role == 'admin') {
          Get.to(() => AdminDashboard());
        } else {
          // Rôle non reconnu
          Get.snackbar('Erreur', 'Rôle utilisateur non reconnu');
        }
      } else {
        Get.snackbar('Erreur', 'Email ou mot de passe invalide');
        print('Échec de la connexion: Email ou mot de passe invalide');
      }
    } catch (e) {
      print('Erreur: ${e.toString()}');
      Get.snackbar('Erreur', 'Une erreur est survenue: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
