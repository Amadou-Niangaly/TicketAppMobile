class Utilisateur {
  String id;
  String nom;
  String prenom;
  DateTime dateNaissance;
  String role;
  String email;
  String telephone;
  String password;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.role,
    required this.email,
    required this.telephone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance.toIso8601String(),
      'role': role,
      'email': email,
      'telephone': telephone,
    };
  }
}
