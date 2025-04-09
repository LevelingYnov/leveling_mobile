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
      print(userData);
      username = userData['username'];
      role = userData['userRole'];
      avatar = userData['avatar'];
      points = userData['points'];
      userId = userData['userId'];

      print("Utilisateur chargé: $username, Role: $role, Avatar: $avatar, Points: $points, ID: $userId");

      notifyListeners();
    } else {
      print("Aucune donnée utilisateur trouvée.");
    }
  }

  void clearUser() {
    username = null;
    role = null;
    avatar = null;
    points = null;
    userId = null;
    notifyListeners();
  }
}
