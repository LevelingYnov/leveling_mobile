import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leveling_mobile/services/auth_service.dart';
import 'package:leveling_mobile/providers/user_provider.dart';
import 'package:leveling_mobile/screens/delayed_animation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authStatus = await AuthService.checkAuthentication();

      if (authStatus['isAuthenticated']) {
        await context.read<UserProvider>().loadUserData();

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Erreur lors de la vérification de l\'authentification: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Veuillez remplir tous les champs'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authResult = await AuthService.handleAuthentication(
        _emailController.text,
        _passwordController.text,
      );

      if (authResult['success']) {
        await context.read<UserProvider>().loadUserData();

        if (mounted) {
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authResult['message']),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        print('Erreur de connexion: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de connexion: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(54, 59, 252, 1),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Center(
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
                          "Connexion",
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
                          onPressed: _login,
                          child:
                              Text("CONNEXION", style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      SizedBox(height: 20),
                      DelayedAnimation(
                        delay: 1000,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _navigateToRegister,
                          child:
                              Text("REGISTER", style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
