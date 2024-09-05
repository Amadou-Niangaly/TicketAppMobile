import 'package:flutter/material.dart';

class ModifierProfilPage extends StatelessWidget {
  const ModifierProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier profil"),

      ),
      body: const Center(
        child: Text("Mofier le profil"),
      ),
    );
  }
}