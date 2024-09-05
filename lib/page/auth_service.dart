import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await createUserDocument(
        userCredential.user!,
        'Nom par défaut',
        'Prénom par défaut',
        'Utilisateur',
        'Date de naissance non disponible',
        'Téléphone non disponible',
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Erreur: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await ensureUserDocument(userCredential.user!);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Erreur: $e");
      return null;
    }
  }

  Future<void> createUserDocument(
    User user,
    String nom,
    String prenom,
    String role,
    String dateNaissance,
    String telephone,
  ) async {
    final userDoc = _firestore.collection('utilisateurs').doc(user.uid);
    await userDoc.set({
      'nom': nom,
      'prenom': prenom,
      'email': user.email ?? 'Email non disponible',
      'telephone': telephone,
      'role': role,
      'dateNaissance': dateNaissance,
    });
  }

  Future<void> ensureUserDocument(User user) async {
    final userDoc = _firestore.collection('utilisateurs').doc(user.uid);
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await createUserDocument(
        user,
        'Nom par défaut',
        'Prénom par défaut',
        'Utilisateur',
        'Date de naissance non disponible',
        'Téléphone non disponible',
      );
    }
  }
}
