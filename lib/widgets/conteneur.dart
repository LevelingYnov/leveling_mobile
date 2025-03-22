import 'package:flutter/material.dart';
import 'dart:ui'; // Pour utiliser BackdropFilter
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget buildHeader(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context);

  return Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: 329,
          height: 75,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(5, 9, 28, 1.0),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 51,
                height: 51,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: userProvider.avatar != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: userProvider.avatar ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            print('Error loading image: $error'); // Ajoutez ce print pour déboguer
                            return Icon(Icons.error, color: Colors.red);
                          },
                          placeholder: (context, url) => CircularProgressIndicator(),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userProvider.username ?? 'Nom d\'utilisateur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${userProvider.points ?? 0} points',
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
  );
}

Widget buildMainContainer() {
  return Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: 329,
          height: 541,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(5, 9, 28, 1.0),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Titre Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Sous-titre descriptif.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              buildSubContainer(),
              SizedBox(height: 20),
              Text(
                'Deuxième sous-titre.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              buildSubContainer(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(69, 74, 222, 1),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Bouton Bleu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildSubContainer() {
  return Container(
    width: double.infinity,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.pinkAccent,
    ),
    child: Center(
      child: Text(
        'Conteneur Rose',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
