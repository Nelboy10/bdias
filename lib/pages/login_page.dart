import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Connexion Firebase à venir 🔐")),
            );
          },
          icon: const Icon(Icons.login),
          label: const Text("Connexion utilisateur"),
        ),
      ),
    );
  }
}
