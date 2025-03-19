import 'package:flutter/material.dart';

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arrosage des Plantes',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}*/

class HomePage extends StatefulWidget {
  @override
  Home createState() => Home();
}


class Home extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rectangle avec bords arrondis'),
        ),
        body: Center(
          child: Container(
            width: 329,
            height: 75,
            decoration: BoxDecoration(
              color: Colors.blue, // Couleur de fond du rectangle
              borderRadius: BorderRadius.circular(15), // Bords arrondis
              border: Border.all(
                color: Colors.black, // Couleur de la bordure
                width: 2, // Épaisseur de la bordure
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
    );
  }
}