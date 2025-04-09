import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:leveling_mobile/services/api_service.dart';

class EventProvider with ChangeNotifier {
  final ApiService apiService;

  List<dynamic> _events = [];
  List<dynamic> get events => _events;

  EventProvider({required this.apiService});

  Future<void> fetchEvents() async {
    try {
      final response = await apiService.request('GET', '/events/readAll');
      if (response.statusCode == 200) {
        _events = jsonDecode(response.body);
        print("Événements récupérés: $_events");
        notifyListeners();
      } else {
        throw Exception('Erreur lors de la récupération des événements');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des événements: $e');
    }
  }

  Future<void> createEvent(String eventType, String startTime, String endTime) async {
    try {
      final response = await apiService.request(
        'POST',
        '/events/create',
        body: {
          'event_type': eventType,
          'start_time': startTime,
          'end_time': endTime,
        },
      );
      if (response.statusCode == 201) {
        await fetchEvents();
      } else {
        throw Exception('Erreur lors de la création de l’événement');
      }
    } catch (e) {
      throw Exception('Erreur lors de la création de l’événement: $e');
    }
  }
}
