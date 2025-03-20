import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:leveling_mobile/routes/router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
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