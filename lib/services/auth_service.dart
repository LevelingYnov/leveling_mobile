import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String _apiUrl = 'http://localhost:5000/api/auth/login';

  static Future<String> login(String identifier, String password) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': identifier.trim(),
        'password': password.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String token = data['accessToken']; // Correction ici

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      return 'Connexion réussie';
    } else {
      final errorData = jsonDecode(response.body);
      return errorData['message'] ?? 'Erreur inconnue';
    }
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // // Supprimer le token pour tester
    // await prefs.remove('jwt_token'); // Cela supprime temporairement le token

    // Récupérer le token supprimé (sera null maintenant)
    String? token = prefs.getString('jwt_token');
    print("Token récupéré après suppression: $token");

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

          if (expirationDate.isBefore(DateTime.now())) {
            return false;
          }

          return true;
        }
      } catch (e) {
        return false;
      }
    }

    return false;
  }
}
