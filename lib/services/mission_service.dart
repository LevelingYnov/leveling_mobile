import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';

class MissionService {
  static final ApiService _apiService = ApiService();

  static Future<Map<String, dynamic>> triggerMissionEvent(
      String eventType) async {
    final response = await _apiService.request(
      'POST',
      '/missions/trigger',
      body: {'event_type': eventType},
    );

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 403) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to trigger mission event: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> checkMissionStatus(
      String missionType) async {
    final response = await _apiService.request(
      'POST',
      '/missions/status',
      body: {'mission_type': missionType},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check mission status: ${response.statusCode}');
    }
  }
}