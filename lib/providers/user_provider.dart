import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? username;
  String? role;

  Future<void> loadUserData() async {
    await Future.delayed(Duration(seconds: 1)); // Simule un appel API
    username = "John Doe";
    role = "USER";
    notifyListeners(); // Notifier les widgets écoutant ce provider
  }
}
