import 'package:flutter/material.dart';
import 'package:leveling_mobile/pages/home.dart';
import 'package:leveling_mobile/pages/login_register.dart';
import 'package:leveling_mobile/services/auth_service.dart';
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Vérifier l'état de l'authentification de manière asynchrone
    return MaterialPageRoute(
      builder: (context) {
        return FutureBuilder<bool>(
          future:
              AuthService.isAuthenticated(), // Vérifie si l'utilisateur est authentifié
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Si en cours de vérification, afficher un loader
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasData && snapshot.data == true) {
              // Si authentifié, charger les données de l'utilisateur
              return Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.username == null) {
                    // Si les données de l'utilisateur ne sont pas encore chargées
                    userProvider.loadUserData();
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // Vérification des rôles et redirection en fonction des rôles
                  if (userProvider.role != null) {
                    // if (userProvider.roles!.contains('ROLE_SUPERADMIN')) {
                    //   return AdminPage(); // Page spécifique pour un administrateur
                    // }
                    // Si l'utilisateur n'est pas un admin, il peut aller sur la HomePage
                    return HomePage();
                  } else {
                    // Si les rôles ne sont pas encore disponibles, afficher un loader
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            } else {
              // Sinon, rediriger vers la LoginPage
              return LoginPage();
            }
          },
        );
      },
    );
  }
}