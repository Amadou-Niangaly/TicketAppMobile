import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_app/page/modifier_profil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text('Utilisateur non connecté'),
        ),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(currentUser.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Erreur: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            body: Center(
              child: Text('Données utilisateur non trouvées'),
            ),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFB),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Photo de profil avec l'icône de caméra
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      backgroundImage: userData['photoUrl'] != null
                          ? NetworkImage(userData['photoUrl'])
                          : const AssetImage('assets/images/default.png') as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.camera_alt, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Nom de l'utilisateur
                Text(
                  userData['nom'] ?? 'Nom inconnu',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Statut
                Text(
                  userData['role'] ?? 'Rôle inconnu',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),

                // Email
                Text(
                  userData['email'] ?? 'Email inconnu',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 8),

                // Numéro de téléphone
                Text(
                  userData['telephone'] ?? 'Téléphone inconnu',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Bouton de déconnexion
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      // Déconnexion de l'utilisateur
                      await FirebaseAuth.instance.signOut();
                      // Navigation vers la page de connexion après déconnexion
                      Navigator.of(context).pushReplacementNamed('/loginPage');
                    } catch (e) {
                      // Afficher un message d'erreur si la déconnexion échoue
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur lors de la déconnexion: $e'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Déconnexion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Spacer(),

                // Bouton de modification
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ModifierProfilPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5F67EA), // Changez la couleur selon vos besoins
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50), // Bouton plein largeur
                  ),
                  child: const Text(
                    'Modifier',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
