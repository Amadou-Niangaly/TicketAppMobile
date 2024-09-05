import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_app/page/search_bar.dart';

class ListUsersPage extends StatelessWidget {
  const ListUsersPage({super.key});

  Future<bool> _isAdmin() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(currentUser.uid)
          .get();
      final userData = userDoc.data();
      if (userData != null && userData['role'] == 'Admin') {
        return true; // L'utilisateur est admin
      }
    }
    return false; // L'utilisateur n'est pas admin
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          // Si l'utilisateur n'est pas admin, afficher un message d'erreur ou rediriger
          return const Center(
            child: Text("Accès refusé : vous n'êtes pas administrateur."),
          );
        }

        // Si l'utilisateur est admin, afficher la liste des utilisateurs
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SearchSection(),
                const SizedBox(height: 12),
                const Text(
                  "USERS",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('utilisateurs')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final users = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index].data() as Map<String, dynamic>;
                        final userId = users[index].id;

                        return Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${user['prenom']} ${user['nom']}",
                                      style: const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${user['role']}",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final updatedUserData = await _showEditDialog(
                                        context,
                                        user['prenom'],
                                        user['nom'],
                                        user['role'],
                                        user['dateNaissance'],
                                        user['email'],
                                        user['telephone'],
                                      );
                                      if (updatedUserData != null) {
                                        await FirebaseFirestore.instance
                                            .collection('utilisateurs')
                                            .doc(userId)
                                            .update(updatedUserData);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      bool? confirmed = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Supprimer l'utilisateur"),
                                            content: const Text(
                                                "Êtes-vous sûr de vouloir supprimer cet utilisateur ?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(false), // Ne pas supprimer
                                                child: const Text("Annuler"),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(true), // Confirmer suppression
                                                child: const Text("Supprimer"),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (confirmed == true) {
                                        await FirebaseFirestore.instance
                                            .collection('utilisateurs')
                                            .doc(userId)
                                            .delete();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 Future<Map<String, dynamic>?> _showEditDialog(
  BuildContext context,
  String prenom,
  String nom,
  String currentRole,
  String dateNaissance,
  String email,
  String telephone,
) async {
  final prenomController = TextEditingController(text: prenom);
  final nomController = TextEditingController(text: nom);
  final dateNaissanceController = TextEditingController(text: dateNaissance);
  final emailController = TextEditingController(text: email);
  final telephoneController = TextEditingController(text: telephone);

  final roles = ['Admin', 'Formateur', 'Apprenant'];
  String? selectedRole = currentRole;

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Modifier l'utilisateur"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: prenomController,
                decoration: const InputDecoration(labelText: "Prénom"),
              ),
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: "Nom"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: telephoneController,
                decoration: const InputDecoration(labelText: "Téléphone"),
              ),
              TextField(
                controller: dateNaissanceController,
                decoration: const InputDecoration(labelText: "Date de Naissance"),
              ),
              DropdownButton<String>(
                value: selectedRole,
                items: roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedRole = value;
                },
                hint: const Text("Sélectionnez un rôle"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null), // Annuler
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop({
                'prenom': prenomController.text,
                'nom': nomController.text,
                'role': selectedRole,
                'dateNaissance': dateNaissanceController.text,
                'email': emailController.text,
                'telephone': telephoneController.text,
              });
            },
            child: const Text("Sauvegarder"),
          ),
        ],
      );
    },
  );
}
}
