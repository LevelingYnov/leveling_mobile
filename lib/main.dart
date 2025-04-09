import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:leveling_mobile/routes/router.dart';
import 'package:leveling_mobile/services/api_service.dart';
import 'package:leveling_mobile/providers/event_provider.dart';
void main() async {
  await dotenv.load();
  final apiService = ApiService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider(apiService: apiService)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leveling',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 30, 30, 30),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0x0092FDFF),
        ),
      ),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}