import 'dart:io';
import 'dart:typed_data';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final dynamic image; // Uint8List pour web, File pour mobile
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.image,
    required this.createdAt,
  });

  // Helper pour générer un ID unique
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}