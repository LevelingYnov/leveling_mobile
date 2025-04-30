import 'package:flutter/material.dart';
import 'package:leveling_mobile/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  String? username;
  String? role;
  String? avatar;
  int? points;
  int? userId;

  Future<void> loadUserData() async {
    if (username != null && role != null && avatar != null && points != null) return;

    var userData = await AuthService.getUserData();

    if (userData != null) {
      username = userData['username'];
      role = userData['userRole'];
      avatar = userData['avatar'];
      points = userData['points'];
      userId = userData['userId'];

      notifyListeners();
    } else {
      print("Aucune donnée utilisateur trouvée.");
    }
  }

  void clearUserData() {
    username = null;
    role = null;
    avatar = null;
    points = null;
    userId = null;
    notifyListeners();
  }
}