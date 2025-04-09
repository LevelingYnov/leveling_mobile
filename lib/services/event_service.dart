import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  static const String _baseUrl = 'http://localhost:5000/api/events';

  // Lire tous les événements de l'utilisateur
  static Future<List<dynamic>> getAllEvents(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/readAll'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des événements');
    }
  }

  // Créer un nouvel événement
  static Future<Map<String, dynamic>> createEvent(
    String token,
    String eventType,
    String startTime,
    String endTime,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'event_type': eventType,
        'start_time': startTime,
        'end_time': endTime,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de la création de l’événement');
    }
  }
}
