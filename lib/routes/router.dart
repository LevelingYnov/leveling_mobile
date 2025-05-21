import 'package:flutter/material.dart';
import 'package:leveling_mobile/pages/home.dart';
import 'package:leveling_mobile/pages/login.dart';
import 'package:leveling_mobile/pages/register.dart';
import 'package:leveling_mobile/pages/mission_page.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print('Navigation: Route ${settings.name} appelée avec arguments: $args');

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());

      case '/home':
        print('Navigation: Redirection vers Home');
        return MaterialPageRoute(builder: (_) => HomePage());

      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());

      case '/mission':
        return MaterialPageRoute(builder: (_) => MissionPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route non trouvée: ${settings.name}'),
            ),
          ),
        );
    }
  }
}