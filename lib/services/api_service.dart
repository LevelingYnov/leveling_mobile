import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fonction pour obtenir un IOClient sécurisé
HttpClient getHttpClient() {
  HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (cert, host, port) => true;
  return httpClient;
}

IOClient getIoClient() {
  return IOClient(getHttpClient());
}

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL']!;
  final IOClient client = getIoClient(); // Utilisation du client sécurisé

  // Récupération du token JWT
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Méthode générique pour gérer GET, POST, PUT, DELETE
  Future<http.Response> request(
    String method,
    String endpoint,
    {Map<String, dynamic>? body}
  ) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Authorization': token != null ? 'Bearer $token' : '',
      'Content-Type': 'application/json',
    };

    try {
      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await client.get(uri, headers: headers); // Utilisation du client sécurisé
          break;
        case 'POST':
          response = await client.post(uri, headers: headers, body: jsonEncode(body));
          break;
        case 'PUT':
          response = await client.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case 'DELETE':
          response = await client.delete(uri, headers: headers);
          break;
        default:
          throw Exception('❌ Méthode HTTP non supportée : $method');
      }

      _handleErrors(response);
      return response;
    } catch (e) {
      throw Exception('❌ Erreur de connexion : $e');
    }
  }

  // Gestion des erreurs
  void _handleErrors(http.Response response) {
    if (response.statusCode >= 400) {
      try {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Erreur inconnue';
        throw Exception('❌ ${response.statusCode} : $errorMessage');
      } catch (e) {
        throw Exception('❌ ${response.statusCode} : ${response.reasonPhrase}');
      }
    }
  }
}