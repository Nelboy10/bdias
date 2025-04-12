import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produits disponibles")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 5, // à remplacer par les données Firestore plus tard
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.eco, color: Colors.green),
            title: Text("Produit Agricole #$index"),
            subtitle: const Text("Exemple : Maïs, Manioc, etc."),
          ),
        ),
      ),
    );
  }
}
