import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_app/page/users.dart';

class UtilisateurService {
  final CollectionReference _utilisateurCollection =
      FirebaseFirestore.instance.collection('utilisateurs');

  Future<void> createUser(Utilisateur utilisateur) async {
    try {
      await _utilisateurCollection.doc(utilisateur.id).set(utilisateur.toMap());
    } catch (e) {
      print("Erreur lors de la création de l'utilisateur: $e");
    }
  }

  // Méthode pour récupérer un utilisateur par son ID (optionnel)
  Future<Utilisateur?> getUserById(String id) async {
    try {
      DocumentSnapshot doc = await _utilisateurCollection.doc(id).get();
      if (doc.exists) {
        return Utilisateur(
          id: doc.id,
          nom: doc['nom'],
          prenom: doc['prenom'],
          dateNaissance: DateTime.parse(doc['dateNaissance']),
          role: doc['role'],
          email: doc['email'],
          telephone: doc['telephone'], password: '',
        );
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur: $e");
    }
    return null;
  }
}
