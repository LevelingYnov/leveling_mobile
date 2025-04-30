import 'package:flutter/material.dart';
import '../widgets/conteneur.dart'; // Importation des widgets séparés
import 'package:provider/provider.dart';
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:leveling_mobile/services/auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  bool _isLoading = false;

  // Fonction pour gérer la déconnexion
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Appel au service de déconnexion
      await AuthService.logout(context);

    } catch (e) {
      // En cas d'erreur, afficher un message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la déconnexion'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond d'écran
          Positioned.fill(
            child: Image.asset(
              'lib/assets/leveling_fond1.png',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay de couleur
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(5, 9, 28, 0.85),
              ),
            ),
          ),
          // Bouton de déconnexion en haut à gauche
          Positioned(
            top: 40,
            left: 20,
            child: SafeArea(
              child: _isLoading 
                ? Container(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: _logout,
                      tooltip: 'Déconnexion',
                    ),
                  ),
            ),
          ),
          // Contenu principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHeader(context),
                SizedBox(height: 20),
                buildMainContainer(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}