import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  File? _productImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Simulation d'envoi des données
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text("Succès"),
          ],
        ),
        content: const Text("Le produit a été ajouté avec succès"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    _quantityController.text = '1';
    setState(() {
      _productImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau Produit Agricole"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green.shade800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section photo avec effet de profondeur
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: _pickImage,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade50,
                    ),
                    child: _productImage == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 50,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Ajouter une photo du produit",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Cliquez pour sélectionner",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                        : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _productImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Section formulaire
              _buildFormSection(),

              // Bouton d'ajout
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.green.shade300,
                  ),
                  child: const Text(
                    "PUBLIER LE PRODUIT",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Nom du produit
        _buildInputField(
          controller: _nameController,
          label: "Nom du produit",
          icon: Icons.shopping_basket,
          validator: (value) => value == null || value.isEmpty ? "Ce champ est requis" : null,
        ),
        const SizedBox(height: 20),

        // Prix
        _buildInputField(
          controller: _priceController,
          label: "Prix (FCFA)",
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
          validator: (value) => value == null || value.isEmpty ? "Ce champ est requis" : null,
        ),
        const SizedBox(height: 20),

        // Quantité
        _buildInputField(
          controller: _quantityController,
          label: "Quantité disponible",
          icon: Icons.format_list_numbered,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return "Ce champ est requis";
            if (int.tryParse(value) == null) return "Entrez un nombre valide";
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Description
        TextFormField(
          controller: _descController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: "Description détaillée",
            labelStyle: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green.shade700, width: 1.5),
            ),
            prefixIcon: Icon(
              Icons.description,
              color: Colors.grey.shade600,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          style: TextStyle(color: Colors.grey.shade800),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green.shade700, width: 1.5),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade600,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      style: TextStyle(color: Colors.grey.shade800),
      validator: validator,
    );
  }
}