import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leveling_mobile/providers/user_provider.dart';

class AuthService {
  static const String _apiUrl = 'http://localhost:5000/api/auth';

  static Future<String> login(String identifier, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': identifier.trim(),
        'password': password.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String token = data['accessToken'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      return 'Connexion réussie';
    } else {
      final errorData = jsonDecode(response.body);
      return errorData['message'] ?? 'Erreur inconnue';
    }
  }

  static Future<bool> refreshToken() async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/refreshToken'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String newToken = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', newToken);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erreur lors du rafraîchissement du token: $e');
      return false;
    }
  }

  static Future<String> checkAndRefreshToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      if (token == null) {
        return 'Token non trouvé';
      }

      final testResponse = await http.get(
        Uri.parse('$_apiUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (testResponse.statusCode == 401) {
        final refreshSuccess = await refreshToken();

        if (refreshSuccess) {
          return 'Token rafraîchi avec succès';
        } else {
          return 'Session expirée, veuillez vous reconnecter';
        }
      }

      return 'Token valide';
    } catch (e) {
      print('Erreur lors de la vérification du token: $e');
      return 'Erreur lors de la vérification du token';
    }
  }

  static Future<Map<String, dynamic>> handleAuthentication(
      String identifier, String password) async {
    final loginResult = await login(identifier, password);

    return {
      'success': loginResult == 'Connexion réussie',
      'message': loginResult,
    };
  }

  static Future<Map<String, dynamic>> checkAuthentication() async {
    final result = await checkAndRefreshToken();

    if (result == 'Token valide' || result == 'Token rafraîchi avec succès') {
      return {
        'isAuthenticated': true,
        'message': result,
      };
    } else if (result == 'Session expirée, veuillez vous reconnecter') {
      return {
        'isAuthenticated': false,
        'requireLogin': true,
        'message': result,
      };
    } else {
      return {
        'isAuthenticated': false,
        'message': result,
      };
    }
  }

  static Future<String> register(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username.trim(),
        'email': email.trim(),
        'password': password.trim(),
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final String token = data['accessToken'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      return 'Inscription réussie';
    } else {
      final errorData = jsonDecode(response.body);
      return errorData['message'] ?? 'Erreur inconnue';
    }
  }

  static Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    UserProvider userProvider = UserProvider();
    userProvider.clearUserData();
    await Future.delayed(Duration(milliseconds: 100));

    Navigator.pushReplacementNamed(context, '/login');
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      try {
        List<String> parts = token.split(".");
        if (parts.length != 3) {
          print("Token JWT invalide !");
          return null;
        }

        String payload = parts[1];
        String normalizedPayload = base64.normalize(payload);
        String decodedPayload = utf8.decode(base64.decode(normalizedPayload));

        Map<String, dynamic> decodedToken = jsonDecode(decodedPayload);

        return decodedToken;
      } catch (e) {
        print("Erreur lors du décodage du token: $e");
        return null;
      }
    }
    return null;
  }

  static Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      try {
        Map<String, dynamic> decodedToken = jsonDecode(
            ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

        if (decodedToken.containsKey('exp')) {
          int expirationTime = decodedToken['exp'];
          DateTime expirationDate =
              DateTime.fromMillisecondsSinceEpoch(expirationTime * 1000);

          return expirationDate.isAfter(DateTime.now());
        }
      } catch (e) {
        print("Erreur lors de la vérification du token: $e");
        return false;
      }
    }

    return false;
  }
}