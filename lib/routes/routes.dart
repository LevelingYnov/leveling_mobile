import 'package:flutter/material.dart';
import 'package:leveling_mobile/pages/home.dart';
import 'package:leveling_mobile/pages/login.dart';
import 'package:leveling_mobile/pages/register.dart';

Widget getPageForRoute(BuildContext context, String route, {dynamic arguments}) {

  switch (route) {
    case '/home':
      return HomePage();
    case '/register':
      return RegisterPage();
    case '/login':
      return LoginPage();
    // Ajoutez d'autres routes ici
    default:
      return HomePage(); // Route par défaut
  }
}