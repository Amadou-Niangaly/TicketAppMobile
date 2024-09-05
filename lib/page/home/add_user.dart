import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_app/page/auth_service.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _dateNaissanceController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text("Nouveau Utilisateur"),
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
            _buildTextField("Nom", _nomController, "Coulibaly"),
            _buildTextField("Prenom", _prenomController, "Moussa"),
            _buildDatePicker("Date Naissance", _dateNaissanceController),
            _buildRolePicker("Role", _roleController),
            _buildTextField("Email", _emailController, "govlog@gmail.com"),
            _buildTextField("Telephone", _telephoneController, "999-999-999"),
            _buildTextField("Mot de Passe", _passwordController, "********", obscureText: true),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: _createUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F67EA),
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                ),
                child: const Text("Créer", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor:Theme.of(context).hintColor.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildDatePicker(String label, TextEditingController controller) {
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
            hintText: "01/01/2000",
            filled: true,
            fillColor: Theme.of(context).hintColor.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none
            ),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setState(() {
                controller.text = "${pickedDate.toLocal()}".split(' ')[0];
              });
            }
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildRolePicker(String label, TextEditingController controller) {
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
            hintText: "Apprenant",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none
            ),
            filled: true,
            fillColor: Theme.of(context).hintColor.withOpacity(0.1),
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          readOnly: true,
          onTap: () async {
            final selectedRole = await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Choisissez un rôle'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        ListTile(
                          title: const Text('Apprenant'),
                          onTap: () {
                            Navigator.pop(context, 'Apprenant');
                          },
                        ),
                        ListTile(
                          title: const Text('Formateur'),
                          onTap: () {
                            Navigator.pop(context, 'Formateur');
                          },
                        ),
                        ListTile(
                          title: const Text('Admin'),
                          onTap: () {
                            Navigator.pop(context, 'Admin');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
            if (selectedRole != null) {
              setState(() {
                controller.text = selectedRole;
              });
            }
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Future<void> _createUser() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final dateNaissance = _dateNaissanceController.text.trim();
    final role = _roleController.text.trim();
    final email = _emailController.text.trim();
    final telephone = _telephoneController.text.trim();
    final password = _passwordController.text.trim();

    try {
      AuthService authService = AuthService();
      User? user = await authService.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        await authService.createUserDocument(
          user,
          nom.isNotEmpty ? nom : 'Nom par défaut',
          prenom.isNotEmpty ? prenom : 'Prénom par défaut',
          role.isNotEmpty ? role : 'Apprenant',
          dateNaissance.isNotEmpty ? dateNaissance : 'Date de naissance non disponible',
          telephone.isNotEmpty ? telephone : 'Téléphone non disponible',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur créé avec succès')),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création de l\'utilisateur: $e')),
      );
    }
  }
}
