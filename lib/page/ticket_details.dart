import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Assurez-vous que le constructeur de TicketDetailsPage accepte le paramètre 'reponse'
class TicketDetailsPage extends StatefulWidget {
  TicketDetailsPage({
    Key? key,
    required this.ticketId,
    required this.sujet,
    required this.probleme,
    required this.categorie,
    required this.email,
    required this.telephone,
    required this.date,
    required this.reponse, // Ajouté ici
  }) : super(key: key);

  final String ticketId;
  final String sujet;
  final String probleme;
  final String categorie;
  final String email;
  final String telephone;
  final DateTime date;
  final String reponse; // Ajouté ici

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  final TextEditingController _reponseController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the response from Firestore
    _reponseController.text = widget.reponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(
          child: Text("Détails du Ticket"),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete,color: Colors.red,),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('tickets').doc(widget.ticketId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Aucun ticket trouvé.'));
          }

          final ticketData = snapshot.data!.data() as Map<String, dynamic>;
          final reponse = ticketData['reponse'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Sujet', widget.sujet),
                        _buildDetailRow('Problème', widget.probleme),
                        _buildDetailRow('Catégorie', widget.categorie),
                        _buildDetailRow('Email', widget.email),
                        _buildDetailRow('Téléphone', widget.telephone),
                        _buildDetailRow('Date', DateFormat('dd MMM yyyy à HH:mm').format(widget.date)),
                        const SizedBox(height: 16.0),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withOpacity(0.1),
                            border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Réponse:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                reponse.isNotEmpty ? reponse : 'Aucune réponse pour le moment.',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _dialogBuilder(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5F67EA),
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'Répondre',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded
            (
            flex: 2,
            child: Text(
              '$title:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              content,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Répondre au Ticket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _reponseController,
                decoration: const InputDecoration(
                  labelText: 'Réponse',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: () {
                      // Code pour choisir une image
                    },
                  ),
                  const Text('Ajouter une image'),
                ],
              ),
              if (_imagePath != null) ...[
                const SizedBox(height: 16.0),
                Image.file(File(_imagePath!)),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5F67EA),
              ),
              child: const Text('Traiter'),
              onPressed: () async {
                await _updateTicketInFirestore();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateTicketInFirestore() async {
    final String reponse = _reponseController.text;

    // Mise à jour du ticket dans Firestore
    await FirebaseFirestore.instance.collection('tickets').doc(widget.ticketId).update({
      'reponse': reponse,
      'status': 'RESOLU',
    });
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la Suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce ticket ? Cette action est irréversible.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5F67EA),
              ),
              child: const Text('Supprimer',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await _deleteTicketFromFirestore();
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Revenir à la liste des tickets après la suppression
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTicketFromFirestore() async {
    // Suppression du ticket de Firestore
    await FirebaseFirestore.instance.collection('tickets').doc(widget.ticketId).delete();
  }
}
