import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leveling_mobile/services/auth_service.dart';
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:leveling_mobile/screens/delayed_animation.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 Future<void> _register() async {
  if (_usernameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Veuillez remplir tous les champs'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  String result = await AuthService.register(
    _usernameController.text,
    _emailController.text,
    _passwordController.text,
  );

  if (result == 'Profil créé avec succès') {

    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacementNamed(context, '/login');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(54, 59, 252, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DelayedAnimation(
                  delay: 100,
                  child: Image.asset(
                    "lib/assets/logo.png",
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                DelayedAnimation(
                  delay: 200,
                  child: Text(
                    "Créer un compte",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                DelayedAnimation(
                  delay: 400,
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: "Nom utilisateur",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DelayedAnimation(
                  delay: 400,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DelayedAnimation(
                  delay: 600,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Mot de passe",
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                DelayedAnimation(
                  delay: 800,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _register,
                    child: Text("CREE UN COMPTE", style: TextStyle(fontSize: 12)),
                  ),
                ),
                SizedBox(height: 30),
                // DelayedAnimation(
                //   delay: 1000,
                //   child: Image.asset("assets/images/logo.svg", height: 80),
                // ),
                // SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}