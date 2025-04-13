import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart'; // Pour mobile
import 'package:image_picker_web/image_picker_web.dart'; // Pour web
import 'dart:io';
import 'dart:typed_data';

import 'product_model.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  File? _productImageFile;
  Uint8List? _productImageWeb;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final pickedFile = await ImagePickerWeb.getImageAsBytes();
      if (pickedFile != null) {
        setState(() => _productImageWeb = pickedFile);
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _productImageFile = File(pickedFile.path));
      }
    }
  }

  Widget _buildImagePreview() {
    if (kIsWeb) {
      return _productImageWeb != null
          ? Image.memory(_productImageWeb!, fit: BoxFit.cover)
          : _buildPlaceholder();
    } else {
      return _productImageFile != null
          ? Image.file(_productImageFile!, fit: BoxFit.cover)
          : _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey.shade400),
        const SizedBox(height: 10),
        const Text("Ajouter une photo", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        Text("Cliquez pour sélectionner",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: Product.generateId(),
        name: _nameController.text,
        description: _descController.text,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        image: kIsWeb ? _productImageWeb : _productImageFile,
        createdAt: DateTime.now(),
      );

      Navigator.pop(context, newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Produit Agricole"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section photo
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildImagePreview(),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Formulaire
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nom du produit",
                  prefixIcon: Icon(Icons.shopping_basket),
                ),
                validator: (value) => value?.isEmpty ?? true ? "Requis" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Prix (FCFA)",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return "Requis";
                  if (double.tryParse(value!) == null) return "Prix invalide";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantité",
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return "Requis";
                  if (int.tryParse(value!) == null) return "Nombre invalide";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: const Text("PUBLIER LE PRODUIT"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}