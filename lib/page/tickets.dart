import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticket_app/page/ticket_items';
import 'nouveau_ticket.dart';
import 'search_bar.dart';

class TicketPage extends StatelessWidget {
  const TicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SearchSection(),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mes Tickets',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Logique pour filtrer les tickets
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<Stream<QuerySnapshot>>(
                future: _getTicketsStream(), // Future qui retourne un Stream<QuerySnapshot>
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StreamBuilder<QuerySnapshot>(
                    stream: snapshot.data, // Utilisation du Stream obtenu
                    builder: (context, streamSnapshot) {
                      if (!streamSnapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final tickets = streamSnapshot.data!.docs;
                      return ListView.builder(
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = tickets[index].data() as Map<String, dynamic>;

                          return TicketItem(
                            ticketId: tickets[index].id,
                            title: ticket['sujet'],
                            date: (ticket['date'] as Timestamp).toDate(),
                            status: ticket['status'],
                            sujet: ticket['sujet'],
                            probleme: ticket['probleme'],
                            categori: ticket['categorie'],
                            email: ticket['email'],
                            telephone: ticket['telephone'],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NouveauTicketPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5F67EA),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text(
            'Nouveau Ticket',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<Stream<QuerySnapshot>> _getTicketsStream() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.empty();
    }

    final userDoc = FirebaseFirestore.instance.collection('utilisateurs').doc(currentUser.uid);

    try {
      final docSnapshot = await userDoc.get();
      final userRole = docSnapshot.data()?['role'];

      if (userRole == 'Admin' || userRole == 'Formateur') {
        return FirebaseFirestore.instance.collection('tickets').snapshots();
      } else if (userRole == 'Apprenant') {
        return FirebaseFirestore.instance
          .collection('tickets')
          .where('userId', isEqualTo: currentUser.uid)
          .snapshots();
      } else {
        return Stream.empty();
      }
    } catch (error) {
      // Gérer les erreurs ici
      return Stream.empty();
    }
  }
}
