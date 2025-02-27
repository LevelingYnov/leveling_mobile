import 'package:flutter/material.dart';
import 'dart:ui'; // Pour utiliser BackdropFilter

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leveling',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Positioned.fill(
            child: Image.asset(
              'lib/img/leveling_fond1.png',
              fit: BoxFit.cover,
            ),
          ),
          // Filtre de couleur
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(5, 9, 28, 0.85), // Filtre semi-transparent
              ),
            ),
          ),
          // Contenu de la page
          Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      width: 329,
                      height: 75,
                      padding: EdgeInsets.all(12), // Padding intérieur du conteneur
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color.fromRGBO(5, 9, 28, 1.0), // Fond opaque
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(5, 9, 28, 1.0), // Fond opaque en haut
                            Colors.black.withOpacity(0.7), // Dégradé noir en bas
                          ],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alignement en haut
                        children: [
                          // Rond jaune à gauche
                          Container(
                            width: 51,
                            height: 51,
                            margin: EdgeInsets.only(right: 8), // Espacement entre le rond et le texte
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Colonne pour le titre et le sous-texte
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
                            mainAxisSize: MainAxisSize.min, // Réduire la hauteur de la colonne au contenu
                            children: [
                              Text(
                                'Titre',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4), // Espacement entre le titre et le sous-texte
                              Text(
                                'Sous-texte descriptif ici.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),



                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12), // Ajoute un padding de 12
                      child: Container(
                        width: 329,
                        height: 541,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color.fromRGBO(5, 9, 28, 1.0).withOpacity(0.8), // Fond complètement opaque
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(5, 9, 28, 1.0), // Fond opaque en haut
                              Colors.black.withOpacity(0.7), // Dégradé vers le noir en bas
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Conteneur',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}