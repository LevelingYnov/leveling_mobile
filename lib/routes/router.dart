import 'package:flutter/material.dart';
import 'package:leveling_mobile/pages/home.dart';
import 'package:leveling_mobile/pages/login.dart';
import 'package:leveling_mobile/pages/register.dart';
import 'package:leveling_mobile/services/auth_service.dart';
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:leveling_mobile/providers/event_provider.dart';
import 'package:provider/provider.dart';

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