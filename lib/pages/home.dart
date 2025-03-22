import 'package:flutter/material.dart';
import '../widgets/conteneur.dart'; // Importation des widgets séparés
import 'package:provider/provider.dart';
import 'package:leveling_mobile/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {

// @override
// void initState() {
//   super.initState();
//   final userProvider = Provider.of<UserProvider>(context, listen: false);
//   userProvider.loadUserData();
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/leveling_fond1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(5, 9, 28, 0.85),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHeader(context),
                SizedBox(height: 20),
                buildMainContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
