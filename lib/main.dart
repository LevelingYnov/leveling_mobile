import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leveling_mobile/providers/event_provider.dart';
import 'package:leveling_mobile/services/auth_service.dart';
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leveling_mobile/routes/router.dart'; // Fichier contenant generateRoute
import 'package:leveling_mobile/pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // important si tu utilises flutter_dotenv
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AppRouter router = AppRouter(); // Instance de notre générateur de routes
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        // Autres providers si nécessaire
      ],
      child: MaterialApp(
        title: 'Leveling Mobile',
        theme: ThemeData(
          // Configuration du thème
          primaryColor: Color.fromRGBO(54, 59, 252, 1),
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter().generateRoute,// Utiliser notre générateur de routes
        navigatorObservers: [
          // Observateur de navigation pour le débogage
          RouteObserver(),
        ],
      ),
    );
  }
}

// Observateur personnalisé pour le débogage des routes
class RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('Navigation PUSH: ${route.settings.name} (précédent: ${previousRoute?.settings.name})');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('Navigation POP: ${route.settings.name} (maintenant: ${previousRoute?.settings.name})');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('Navigation REPLACE: ${oldRoute?.settings.name} par ${newRoute?.settings.name}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('Navigation REMOVE: ${route.settings.name}');
    super.didRemove(route, previousRoute);
  }
}