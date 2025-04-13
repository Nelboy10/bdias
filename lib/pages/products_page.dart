import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';

import 'add_product_page.dart';
import 'product_model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produits disponibles"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newProduct = await Navigator.push<Product>(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductPage(),
                ),
              );

              if (newProduct != null) {
                setState(() {
                  products.add(newProduct);
                  // Tri par date de création (les plus récents en premier)
                  products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                });
              }
            },
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(
        child: Text(
          "Aucun produit disponible\nCliquez sur + pour ajouter",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) => Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Image du produit
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: products[index].image != null
                      ? kIsWeb
                      ? Image.memory(
                    products[index].image as Uint8List,
                    fit: BoxFit.cover,
                  )
                      : Image.file(
                    products[index].image as File,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.eco, color: Colors.green, size: 40),
                ),
                const SizedBox(width: 16),
                // Détails du produit
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        products[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        products[index].description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${products[index].price} FCFA",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "Qté: ${products[index].quantity}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}