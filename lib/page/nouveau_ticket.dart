import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NouveauTicketPage extends StatefulWidget {
  const NouveauTicketPage({super.key});

  @override
  _NouveauTicketPageState createState() => _NouveauTicketPageState();
}

class _NouveauTicketPageState extends State<NouveauTicketPage> {
  final TextEditingController _sujetController = TextEditingController();
  final TextEditingController _problemeController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void dispose() {
    _sujetController.dispose();
    _problemeController.dispose();
    _categorieController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    final sujet = _sujetController.text;
    final probleme = _problemeController.text;
    final categorie = _categorieController.text;
    final email = _emailController.text;
    final telephone = _telephoneController.text;

    if (sujet.isEmpty || probleme.isEmpty || categorie.isEmpty || email.isEmpty || telephone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final ticketId = FirebaseFirestore.instance.collection('tickets').doc().id;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance.collection('tickets').doc(ticketId).set({
      'ticketId': ticketId,
      'sujet': sujet,
      'probleme': probleme,
      'categorie': categorie,
      'email': email,
      'telephone': telephone,
      'status': 'ATTENTE',
      'reponse': '',
      'date': Timestamp.now(),
      'userId': userId, // Ajout du userId
    });

    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text("Nouveau Ticket"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Sujet", _sujetController, "Entrez le sujet"),
            _buildTextField("Problème", _problemeController, "Décrivez le problème"),
            _buildCategoryPicker("Catégorie", _categorieController),
            _buildTextField("Email", _emailController, "exemple@gmail.com"),
            _buildTextField("Téléphone", _telephoneController, "123-456-789"),
            _buildImagePicker(),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: _submitTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F67EA),
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                ),
                child: const Text(
                  "Soumettre",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor:Theme.of(context).hintColor.withOpacity(0.1),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildCategoryPicker(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Sélectionnez une catégorie",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).hintColor.withOpacity(0.1),
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          readOnly: true,
          onTap: () async {
            final selectedCategory = await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Choisissez une catégorie'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        ListTile(
                          title: const Text('Technique'),
                          onTap: () {
                            Navigator.pop(context, 'Technique');
                          },
                        ),
                        ListTile(
                          title: const Text('Théorique'),
                          onTap: () {
                            Navigator.pop(context, 'Théorique');
                          },
                        ),
                        ListTile(
                          title: const Text('Pratique'),
                          onTap: () {
                            Navigator.pop(context, 'Pratique');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
            if (selectedCategory != null) {
              setState(() {
                controller.text = selectedCategory;
              });
            }
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Charge Image",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.grey[600],
                size: 40.0,
              ),
              onPressed: _pickImage,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Container(
                height: 100.0,
                color: Colors.white,
                child: Center(
                  child: _imageFile == null
                      ? Text(
                          'Aucune image sélectionnée',
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      : Image.file(File(_imageFile!.path)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
